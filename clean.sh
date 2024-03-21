#!/bin/bash

docker stop alces-dashboard-grafana
docker rm alces-dashboard-grafana

docker stop alces-dashboard-proxy
docker rm alces-dashboard-proxy

docker stop alces-dashboard-metrics
docker rm alces-dashboard-metrics

docker stop alces-dashboard-metrics-downsampled
docker rm alces-dashboard-metrics-downsampled

docker stop alces-dashboard-downsampling
docker rm alces-dashboard-downsampling

docker stop alces-dashboard-power-exporter
docker rm alces-dashboard-power-exporter
