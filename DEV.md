
# Dev Workflow
The following information describes the steps required to run a dev version of the Grafana Monitoring dashboard, in order to add/test changes.

The dev workflow for making changes to the monitoring-dashboard requires two installations of monitoring-dashbaord. A dev version, and a staging/production version of Grafana. The two different installations can be deployed from a common source path.

## 1) Downloading source code
```
cd <source-path>/
git clone https://github.com/openflighthpc/monitoring-dashboard
git checkout -b <dev-feature-branch>
```

## 2) Installing dev version
Optionally, you can choose a custom install destination using the env variable `DEPLOY_PATH=<deploy-path>`. If no DEPLOY_PATH is set, the default install path of `/etc/alces-dashboard` will be used

```
cd <source-path>/monitoring-dashboard
DEPLOY_PATH=<dev-deploy-path> bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate <dev-deploy-path>/certs/dashboard.crt
cp /path/to/key <dev-deploy-path>/certs/dashboard.key
```

## 3) Build and Run dev containers
Setting env variable DEV=yes creates docker images with a '-dev' suffix, and ensures that a no auth version of proxy container image is built and run. 
```
cd <source-path>/monitoring-dashboard
DEV=yes DEPLOY_PATH=<dev-deploy-path> bash build.sh
DEV=yes DEPLOY_PATH=<dev-deploy-path> bash run.sh
```
The Grafana dashboard can be accessed on port 443 with the https:// protocol.

## 4) Edit dev Grafana dashboards
Grafana dashboards can be edited after logging to 'https://<Grafana-URL>/admin'. After making the required changes to the Grafana dashboard, 'share' icon next to the dashboard name on top-left can be used to export that dashboard into a json through the website. 

This exported json can be pasted in the relevant provisioned dashboards section of the source code at `monitoring-dashboard/grafana/dashboards/`

A restart of Grafana is required to see the new changes reflected.

## 5) Stop and remove dev dashboard containers
```
DEV=yes bash clean.sh
```

## 6) Installing staging version
```
cd <source-path>/monitoring-dashboard
DEPLOY_PATH=<staging-deploy-path> bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate <staging-deploy-path>/certs/dashboard.crt
cp /path/to/key <staging-deploy-path>/certs/dashboard.key
```

## 7) Build and Run staging containers
Build and run the containers using the bash script. If you do not wish to use sssd configured on the host for authentication, update the build.sh script to build use `docker/proxy-noauth.Dockerfile` instead. 

```
cd <source-path>/monitoring-dashboard
DEPLOY_PATH=<staging-deploy-path> bash build.sh
DEPLOY_PATH=<staging-deploy-path> bash run.sh
```

## 8) Verify changes in staging environment
Make sure that changes made in the source code at monitoring-dashboard/grafana/dashboards/ are applied and working properly in the staging environment. If changes are not working properly, staging environment can be shut down using `bash clean.sh`. Further, dev environment can again be started using build.sh and run.sh scripts as described above in point no 3.

If changes to dashboards are being reflecting properly in the staging version, commit and push.
```
git commit -am "<dev-commit-message>"
git push origin <dev-feature-branch>
```

## 9) Stop and remove staging dashboard containers
```
bash clean.sh
```

## 10) Create Pull Request from Github
Open `https://github.com/openflighthpc/monitoring-dashboard/compare/develop...<dev-feature-branch>` , and create a new Pull Request for review.
