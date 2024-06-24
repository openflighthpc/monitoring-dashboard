
# Dev Workflow

The dev workflow for making changes to the monitoring-dashboard requires two versions of Grafana. A dev version, and a staging/production version of Grafana. The changes made to the dev version of Grafana are exported and copied to the staging/production version.

The following information describes the steps required to run a dev version of the Grafana Monitoring dashboard. 

## 1) Installing dev source code
```
cd <dev-source-path>/
git clone https://github.com/openflighthpc/monitoring-dashboard
git checkout -b <dev-branch>
```

Run the `install.sh` script with env variable `DEV=1`. Optionally, you can choose a custom install destination using the env variable `DEPLOY_PATH=<deploy-path>`. If no DEPLOY_PATH is set, the default install path of `/etc/alces-dashboard` will be used

```
cd <dev-source-path>/monitoring-dashboard
DEV=1 DEPLOY_PATH=<dev-deploy-path> bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate <dev-deploy-path>/certs/dashboard.crt
cp /path/to/key <dev-deploy-path>/certs/dashboard.key
```

## 2) Build and Run dev containers
Build and run the containers using the bash script. If you do not wish to use sssd configured on the host for authentication, update the build script to build use `docker/proxy-noauth.Dockerfile` instead. 
```
cd <dev-source-path>/monitoring-dashboard
DEV=1 DEPLOY_PATH=<dev-deploy-path> bash build.sh
DEV=1 DEPLOY_PATH=<dev-deploy-path> bash run.sh
```

## 3) Edit dev Grafana dashboards
After making the required changes to a Grafana dashboard, export that dashboard into a json through the website. This exported json can be pasted in the relevant dashboard section of the staging/production environment at: monitoring-dashboard/grafana/dashboards/

A restart of Grafana is required to see the new changes reflected.

Commit changes and push to dev-branch
```
git commit -am "<dev-commit-message>"
git push origin <dev-branch>
```

## 4) Stop and remove dev dashboard containers
```
DEV=1 bash clean.sh
```

## 5) Installing staging source code
```
cd <staging-source-path>/
git clone https://github.com/openflighthpc/monitoring-dashboard
git checkout <dev-branch>
cd <staging-source-path>/monitoring-dashboard
DEPLOY_PATH=<staging-deploy-path> bash install.sh
```

Copy your SSL certificate and key.
```
cp /path/to/certificate <staging-deploy-path>/certs/dashboard.crt
cp /path/to/key <staging-deploy-path>/certs/dashboard.key
```

## 6) Build and Run staging containers
Build and run the containers using the bash script. If you do not wish to use sssd configured on the host for authentication, update the build script to build use `docker/proxy-noauth.Dockerfile` instead. 
```
cd <staging-source-path>/monitoring-dashboard
DEPLOY_PATH=<staging-deploy-path> bash build.sh
DEPLOY_PATH=<staging-deploy-path> bash run.sh
```

## 7) Verify changes in staging environment
Make sure that changes pushed to dev-branch are applied and working properly in staging environment. If changes are not working properly, staging environment can be shutdown using `bash clean.sh`. Further, dev environment can again be started using build.sh and run.sh scripts as described above.

## 8) Stop and remove staging dashboard containers
```
bash clean.sh
```

## 9) Create Pull Request from Github
Open `https://github.com/openflighthpc/monitoring-dashboard/compare/master...<dev-branch>` , and create a new Pull Request for review.
