#!/bin/bash

CLUSTER_TRENDS_TAG="2024.0.1"

git clone https://github.com/alces-software/flight-cluster-trends.git /tmp/flight-cluster-trends
pushd /tmp/flight-cluster-trends
git checkout ${CLUSTER_TRENDS_TAG}
git pull
docker build -t alces-dashboard-grafana --network host -f ./Dockerfile ./
popd

docker build -t alces-dashboard-proxy --network host -f ./docker/proxy.Dockerfile ./docker/
docker build -t alces-dashboard-metrics --network host -f ./docker/metrics.Dockerfile ./docker/
docker build -t alces-dashboard-downsampling --network host -f ./docker/downsampling.Dockerfile ./docker/
docker build -t alces-dashboard-power-exporter --network host -f ./docker/power-exporter.Dockerfile ./docker/
