#!/bin/bash

# Grafana config
mkdir -p /etc/alces-dashboard/grafana
cp ./grafana/custom.ini /etc/alces-dashboard/grafana/custom.ini
mkdir -p /etc/alces-dashboard/grafana/dashboards
cp -R ./grafana/dashboards/* /etc/alces-dashboard/grafana/dashboards/

# Metrics config
mkdir -p /etc/alces-dashboard/metrics/{configs,targets}
cp ./metrics/configs/* /etc/alces-dashboard/metrics/configs
cp ./metrics/targets/* /etc/alces-dashboard/metrics/targets

# Downsample config
mkdir -p /etc/alces-dashboard/downsampling/rules
cp -R ./downsampling/rules/* /etc/alces-dashboard/downsampling/rules/

# Power exporter config
mkdir -p /etc/alces-dashboard/power-exporter/
cp -R ./power-exporter/* /etc/alces-dashboard/power-exporter/

# Nginx certs
mkdir -p /etc/alces-dashboard/certs
