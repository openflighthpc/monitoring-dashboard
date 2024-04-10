#!/bin/bash

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-grafana \
	--volume grafana-data:/var/lib/grafana \
	--mount type=bind,source=/etc/alces-dashboard/grafana/custom.ini,target=/etc/grafana/grafana.ini \
	--mount type=bind,source=/etc/alces-dashboard/grafana/dashboards,target=/etc/grafana/dashboards \
	--health-cmd='curl -s --fail http://localhost:3000 || exit 1' \
	alces-dashboard-grafana:latest

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-proxy \
	--mount type=bind,source=/etc/alces-dashboard/certs,target=/etc/nginx/certs \
	--mount type=bind,source=/var/lib/sss/pipes,target=/var/lib/sss/pipes \
	--health-cmd='curl -s --fail http://localhost:80 || exit 1' \
	alces-dashboard-proxy:latest

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-metrics \
	--volume metrics-data:/victoria-metrics-data \
	--mount type=bind,source=/etc/alces-dashboard/metrics/configs,target=/etc/victoria-metrics/configs \
	--mount type=bind,source=/etc/alces-dashboard/metrics/targets,target=/etc/victoria-metrics/targets \
	--health-cmd='curl -s --fail http://localhost:8428/health || exit 1' \
	alces-dashboard-metrics:latest \
	--retentionPeriod=30d \
	--httpListenAddr=localhost:8428 \
	--dedup.minScrapeInterval=60s \
	--promscrape.config=/etc/victoria-metrics/prometheus.yml \
	--promscrape.configCheckInterval=60s

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-metrics-downsampled \
	--volume metrics-downsampled-data:/victoria-metrics-data \
	--health-cmd='curl -s --fail http://localhost:8429/health || exit 1' \
	alces-dashboard-metrics:latest \
	--retentionPeriod=730d \
	--httpListenAddr=localhost:8429 \
	--dedup.minScrapeInterval=3600s \
	--promscrape.configCheckInterval=60s

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-downsampling \
	--mount type=bind,source=/etc/alces-dashboard/downsampling/rules,target=/etc/vmalert/rules \
	--health-cmd='curl -s --fail http://localhost:8880/health || exit 1' \
	alces-dashboard-downsampling:latest \
	--httpListenAddr=localhost:8880 \
	--datasource.url=http://localhost:8428 \
	--remoteWrite.url=http://localhost:8429 \
	--remoteRead.url=http://localhost:8429 \
	--configCheckInterval=60s \
	--rule=/etc/vmalert/rules/*.yaml

docker run -it -d \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-power-exporter \
	--mount type=bind,source=/etc/alces-dashboard/power-exporter,target=/power-exporter/power-exporter/etc \
	--health-cmd='curl -s --fail http://localhost:9106 || exit 1' \
	alces-dashboard-power-exporter:latest
