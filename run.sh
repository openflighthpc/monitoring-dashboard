#!/bin/bash

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-grafana \
	--volume grafana-data:/var/lib/grafana \
	--mount type=bind,source=/etc/alces-dashboard/grafana/custom.ini,target=/etc/grafana/grafana.ini \
	--mount type=bind,source=/etc/alces-dashboard/grafana/dashboards,target=/etc/grafana/dashboards \
	alces-dashboard-grafana:latest

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-proxy \
	--mount type=bind,source=/etc/alces-dashboard/certs,target=/etc/nginx/certs \
	alces-dashboard-proxy:latest

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-metrics \
	--volume metrics-data:/victoria-metrics-data \
	--mount type=bind,source=/etc/alces-dashboard/metrics/configs,target=/etc/victoria-metrics/configs \
	--mount type=bind,source=/etc/alces-dashboard/metrics/targets,target=/etc/victoria-metrics/targets \
	alces-dashboard-metrics:latest \
	--retentionPeriod=30d \
	--httpListenAddr=:8428 \
	--dedup.minScrapeInterval=60s \
	--promscrape.config=/etc/victoria-metrics/prometheus.yml \
	--promscrape.configCheckInterval=60s

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-metrics-downsampled \
	--volume metrics-downsampled-data:/victoria-metrics-data \
	alces-dashboard-metrics:latest \
	--retentionPeriod=730d \
	--httpListenAddr=:8429 \
	--dedup.minScrapeInterval=3600s \
	--promscrape.configCheckInterval=60s

docker run -d -it \
	--network host \
	--restart unless-stopped \
	--name alces-dashboard-downsampling \
	--mount type=bind,source=/etc/alces-dashboard/downsampling/rules,target=/etc/vmalert/rules \
	alces-dashboard-downsampling:latest \
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
	alces-dashboard-power-exporter:latest
