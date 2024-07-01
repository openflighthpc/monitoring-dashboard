#!/bin/bash

if [[ -z "${DEV}" ]]; then

    docker build -t alces-dashboard-grafana --network host -f ./docker/grafana.Dockerfile ./docker/
    docker build -t alces-dashboard-proxy --network host -f ./docker/proxy-noauth.Dockerfile ./docker/
    docker build -t alces-dashboard-metrics --network host -f ./docker/metrics.Dockerfile ./docker/
    docker build -t alces-dashboard-downsampling --network host -f ./docker/downsampling.Dockerfile ./docker/
    docker build -t alces-dashboard-power-exporter --network host -f ./docker/power-exporter.Dockerfile ./docker/

else

    docker build -t alces-dashboard-grafana-dev --network host --build-arg DEV=1  -f ./docker/grafana.Dockerfile ./docker/
    docker build -t alces-dashboard-proxy-dev --network host -f ./docker/proxy-noauth.Dockerfile ./docker/
    docker build -t alces-dashboard-metrics-dev --network host -f ./docker/metrics.Dockerfile ./docker/
    docker build -t alces-dashboard-downsampling-dev --network host -f ./docker/downsampling.Dockerfile ./docker/
    docker build -t alces-dashboard-power-exporter-dev --network host -f ./docker/power-exporter.Dockerfile ./docker/

fi

