
# Dev Workflow

The dev workflow for making changes to the monitoring-dashboard requires two versions of Grafana. A dev version, and a staging/production version of Grafana. The changes made to the dev version of Grafana are exported and copied to the staging/production version.

The following information describes the steps required to run a dev version of the Grafana Monitoring dashboard. After cloning the monitoring-dashboard repo as described here: https://github.com/openflighthpc/monitoring-dashboard/blob/master/README.md, implement the following steps:

* In `monitoring-dashboard/grafana/custom.ini`, edit `org_role` to `Admin`
```
[auth.anonymous]
enabled = true
org_name = Main Org.
org_role = Admin
hide_version = true
```

* In monitoring-dashboard/docker/grafana.Dockerfile, comment the following lines:
```
# RUN echo " #mega-menu-toggle { display: none !important; } .css-xv13ed { display: none !important; } .css-qlgu59 { display: none !important; } .css-adfkf4 { display: none !important; } .css-zanmp0 { display: none !important; } .css-15t8ss1 { display: none !important; } .css-a7i72f-toolbar-button { display: none !important; } .css-18j6u6t { display: none !important; }" >> /usr/share/grafana/public/build/grafana.light.bbe69ddb3979b7904078.css
# RUN echo " #mega-menu-toggle { display: none !important; } .css-xv13ed { display: none !important; } .css-qlgu59 { display: none !important; } .css-adfkf4 { display: none !important; } .css-zanmp0 { display: none !important; } .css-15t8ss1 { display: none !important; } .css-a7i72f-toolbar-button { display: none !important; } .css-18j6u6t { display: none !important; }" >> /usr/share/grafana/public/build/grafana.dark.170498723865582cad9d.css
```

After the above steps have been completed, continue with the install, build, and execute instructions as described here: https://github.com/openflighthpc/monitoring-dashboard/blob/master/README.md

# Edit Grafana dashboards
After making the required changes to a Grafana dashboard, export that dashboard into a json through the website. This exported json can be pasted in the relevant dashboard section of the staging/production environment at: monitoring-dashboard/grafana/dashboards/

A restart of Grafana is required to see the new changes reflected.
