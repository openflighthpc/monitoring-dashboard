
# Monitoring Dashboard
Monitoring Dashboard built upon several common open source projects.
- [Grafana](https://github.com/grafana/grafana)
- [Victoria Metrics](https://github.com/VictoriaMetrics/VictoriaMetrics)
- [Slurm Exporter](https://github.com/vpenso/prometheus-slurm-exporter)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [Node Exporter Textfile Collector Scripts](https://github.com/openflighthpc/node-exporter-textfile-collector-scripts)
- [Power Exporter](https://github.com/openflighthpc/power-exporter)
- [Slurm Job Exporter](https://github.com/openflighthpc/slurm-job-exporter)

## Prerequisites
- Suitable sized host with sufficient storage in `/var` for Docker volumes.
- Docker / Podman installed.
- SSL certificate and keyfile.
- Git
- Optional: sssd configured on the host to provide basic nginx authentication.

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

Build and run the containers using the bash script. If you do not wish to use sssd configured on the host for authentication, update the build script to build use `docker/proxy-noauth.Dockerfile` instead. 
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
Add your list of hosts to `/etc/alces-dashboard/metrics/targets/node-exporter.yml`. Ensure any compute nodes are added with the correct `node_type: compute` label and any core nodes are added with `node_type: core`.
```
- targets:
  - master01:9100
  - master02:9100
  labels:
    node_type: core
- targets:
  - node01:9100
  - node02:9100
  labels:
    node_type: compute
```

### Node Exporter Textfile Collector Scripts
The `slurm-gpu-allocation.sh` script needs to be installed on a suitable host - typically this would be the same host you install Slurm Exporter to. Following the upstream documentation to install this.

### Slurm Exporter
Install this as per the upstream documentation and then update the target file `/etc/alces-dashboard/metrics/targets/slurm-exporter.yml` to include the relevant host. The default configuration assumes this is installed on the same host.
```
- targets:
  - localhost:9103
```

### Slurm Job Exporter
Install this as per the upstream documentation and then update the target file `/etc/alces-dashboard/metrics/targets/slurm-job-exporter.yml` to include the relevant host. The default configuration assumes this is installed on the same host.
```
- targets:
  - localhost:9103
```

### Power Exporter
Configure `config.yaml` and `nodes.yaml` as per the project [README](https://github.com/openflighthpc/power-exporter/blob/master/README.md) and restart the container.
```
vim /etc/alces-dashboard/power-exporter/config.yaml
vim /etc/alces-dashboard/power-exporter/nodes.yaml
docker restart alces-dashboard-power-exporter
```
