
# Dev Workflow

The dev workflow for making changes to the monitoring-dashboard requires two versions of Grafana. A dev version, and a staging/production version of Grafana. The changes made to the dev version of Grafana are exported and copied to the staging/production version.

The following information describes the steps required to run a dev version of the Grafana Monitoring dashboard. 

## Installation
Clone this git repository and checkout the desired branch / release.
```
git clone https://github.com/gsangwell/monitoring-dashboard
git checkout <branch/release>
```

Run the `install.sh` script with env variable `DEV=1`. Optionally, you can choose a custom install destination using the env variable `DEPLOY_PATH=<deploy-path>`. If no DEPLOY_PATH is set, the default install path of `/etc/alces-dashboard` will be used

```
cd monitoring-dashboard
DEV=1 DEPLOY_PATH=<deploy-path> bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate <deploy-path>/certs/dashboard.crt
cp /path/to/key <deploy-path>/certs/dashboard.key
```

## Build and Run containers
Build and run the containers using the bash script. If you do not wish to use sssd configured on the host for authentication, update the build script to build use `docker/proxy-noauth.Dockerfile` instead. 
```
DEV=1 DEPLOY_PATH=<deploy-path> bash build.sh
DEV=1 DEPLOY_PATH=<deploy-path> bash run.sh
```

# Edit Grafana dashboards
After making the required changes to a Grafana dashboard, export that dashboard into a json through the website. This exported json can be pasted in the relevant dashboard section of the staging/production environment at: monitoring-dashboard/grafana/dashboards/

A restart of Grafana is required to see the new changes reflected.

## Stop and remove dashboard containers
```
DEV=1 bash clean.sh
```
