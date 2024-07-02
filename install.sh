#!/bin/bash

if [[ -z "${DEPLOY_PATH}" ]]; then
  DEPLOY_PATH="/etc/alces-dashboard"
fi

# Grafana config
mkdir -p ${DEPLOY_PATH}/grafana
cp ./grafana/custom.ini ${DEPLOY_PATH}/grafana/custom.ini
cp ./grafana/home.json ${DEPLOY_PATH}/grafana/home.json
mkdir -p ${DEPLOY_PATH}/grafana/dashboards
cp -R ./grafana/dashboards/* ${DEPLOY_PATH}/grafana/dashboards/
mkdir -p ${DEPLOY_PATH}/grafana/provisioning
cp -R ./grafana/provisioning/* ${DEPLOY_PATH}/grafana/provisioning/

# Metrics config
mkdir -p ${DEPLOY_PATH}/metrics/{configs,targets}
cp ./metrics/configs/* ${DEPLOY_PATH}/metrics/configs
cp ./metrics/targets/* ${DEPLOY_PATH}/metrics/targets

# Downsample config
mkdir -p ${DEPLOY_PATH}/downsampling/rules
cp -R ./downsampling/rules/* ${DEPLOY_PATH}/downsampling/rules/

# Power exporter config
mkdir -p ${DEPLOY_PATH}/power-exporter/
cp -R ./power-exporter/* ${DEPLOY_PATH}/power-exporter/

# Nginx certs
mkdir -p ${DEPLOY_PATH}/certs

