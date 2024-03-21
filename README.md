# Monitoring Dashboard
Monitoring Dashboard built upon several common open source projects.
- [Grafana](https://github.com/grafana/grafana)
- [Victoria Metrics](https://github.com/VictoriaMetrics/VictoriaMetrics)
- [Slurm Exporter](https://github.com/vpenso/prometheus-slurm-exporter)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [Power Exporter](https://github.com/openflighthpc/power-exporter)

## Prerequisites
- Suitable sized host with sufficient storage in `/var` for Docker volumes.
- Docker / Podman installed.
- SSL certificate and keyfile.
- Git

## Installation
Clone this git repository and checkout the desired branch / release.
```
git clone https://github.com/gsangwell/monitoring-dashboard
git checkout <branch/release>
```

Run the `install.sh` script to install the default configuration files.
```
cd monitoring-dashboard
bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate /etc/alces-dashboard/certs/dashboard.crt
cp /path/to/key /etc/alces-dashboard/certs/dashboard.key
```

Build and run the containers using the bash script.
```
bash build.sh
bash run.sh
```

Update the dashboard admin password.
```
docker exec -it alces-dashboard-grafana /usr/share/grafana/bin/grafana-cli admin reset-admin-password "password"
```

## Configuration
Once deployed, you will need to configure the relevant services to collect metrics from your hosts.

### Node Exporter
Add your list of hosts to `/etc/alces-dashboard/metrics/targets/node-exporter.yml`
```
- targets:
  - node01:9100
  - node02:9100
```

### Slurm Exporter
Add your scheduler host to `/etc/alces-dashboard/metrics/targets/slurm-exporter.yml`
```
- targets:
  - infra01:9100
```

### Power Exporter
Configure `config.yaml` and `nodes.yaml` as per the project [README](https://github.com/openflighthpc/power-exporter/blob/master/README.md) and restart the container.
```
vim /etc/alces-dashboard/power-exporter/config.yaml
vim /etc/alces-dashboard/power-exporter/nodes.yaml
docker restart alces-dashboard-power-exporter
```
