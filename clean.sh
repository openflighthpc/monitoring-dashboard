#!/bin/bash

if [[ -z "${DEV}" ]]; then
  IMAGE_SUFFIX=""
else
  IMAGE_SUFFIX="-dev"
fi

docker stop alces-dashboard-grafana${IMAGE_SUFFIX}
docker rm alces-dashboard-grafana${IMAGE_SUFFIX}

docker stop alces-dashboard-proxy${IMAGE_SUFFIX}
docker rm alces-dashboard-proxy${IMAGE_SUFFIX}

docker stop alces-dashboard-metrics${IMAGE_SUFFIX}
docker rm alces-dashboard-metrics${IMAGE_SUFFIX}

docker stop alces-dashboard-metrics-downsampled${IMAGE_SUFFIX}
docker rm alces-dashboard-metrics-downsampled${IMAGE_SUFFIX}

docker stop alces-dashboard-downsampling${IMAGE_SUFFIX}
docker rm alces-dashboard-downsampling${IMAGE_SUFFIX}

docker stop alces-dashboard-power-exporter${IMAGE_SUFFIX}
docker rm alces-dashboard-power-exporter${IMAGE_SUFFIX}
