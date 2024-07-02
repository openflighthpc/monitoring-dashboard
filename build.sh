#!/bin/bash

if [[ "${DEV}" == "yes" ]]; then
  IMAGE_SUFFIX="-dev"
else
  IMAGE_SUFFIX=""
fi

CLUSTER_TRENDS_TAG="2024.0.2"
git clone https://github.com/alces-software/flight-cluster-trends.git /tmp/flight-cluster-trends
pushd /tmp/flight-cluster-trends
git checkout ${CLUSTER_TRENDS_TAG}
git pull
docker build -t alces-dashboard-grafana${IMAGE_SUFFIX} --network host -f ./Dockerfile ./
popd

if [[ "${DEV}" == "yes" ]]; then
  docker build -t alces-dashboard-proxy${IMAGE_SUFFIX} --network host -f ./docker/proxy-noauth.Dockerfile ./docker/
else
  docker build -t alces-dashboard-proxy${IMAGE_SUFFIX} --network host -f ./docker/proxy.Dockerfile ./docker/
fi

docker build -t alces-dashboard-metrics${IMAGE_SUFFIX} --network host -f ./docker/metrics.Dockerfile ./docker/
docker build -t alces-dashboard-downsampling${IMAGE_SUFFIX} --network host -f ./docker/downsampling.Dockerfile ./docker/
docker build -t alces-dashboard-power-exporter${IMAGE_SUFFIX} --network host -f ./docker/power-exporter.Dockerfile ./docker/
