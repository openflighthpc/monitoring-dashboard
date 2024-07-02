#!/bin/bash

if [[ "${DEV}" == "yes" ]]; then
  IMAGE_SUFFIX="-dev"
  echo "Running clean.sh in dev mode"
else
  IMAGE_SUFFIX=""
  echo "Running clean.sh in prod mode"
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
