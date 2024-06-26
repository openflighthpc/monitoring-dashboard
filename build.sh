#!/bin/bash

docker build -t alces-dashboard-grafana --network host -f ./docker/grafana.Dockerfile ./docker/
docker build -t alces-dashboard-proxy --network host -f ./docker/proxy.Dockerfile ./docker/
docker build -t alces-dashboard-metrics --network host -f ./docker/metrics.Dockerfile ./docker/
docker build -t alces-dashboard-downsampling --network host -f ./docker/downsampling.Dockerfile ./docker/
docker build -t alces-dashboard-power-exporter --network host -f ./docker/power-exporter.Dockerfile ./docker/
