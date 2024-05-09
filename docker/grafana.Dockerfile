FROM docker.io/grafana/grafana-oss:10.2.2

USER root
COPY ./grafana/public/img/* /usr/share/grafana/public/img/
RUN find /usr/share/grafana/public/build -name *.js -exec sed -i 's|AppTitle="Grafana"|AppTitle="Alces Flight Monitoring"|g' {} \;
RUN find /usr/share/grafana/public/build -name *.js -exec sed -i 's|LoginTitle="Welcome to Grafana"|LoginTitle="Welcome to Alces Flight Monitoring"|g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|{target:"_blank",id:"documentation",text:(0,r.t)("nav.help/documentation","Documentation"),icon:"document-info",url:"https://grafana.com/docs/grafana/latest/?utm_source=grafana_footer"},{target:"_blank",id:"support",text:(0,r.t)("nav.help/support","Support"),icon:"question-circle",url:"https://grafana.com/products/enterprise/?utm_source=grafana_footer"},{target:"_blank",id:"community",text:(0,r.t)("nav.help/community","Community"),icon:"comments-alt",url:"https://community.grafana.com/?utm_source=grafana_footer"}||g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|{target:"_blank",id:"version",text:`${e.edition}${s}`,url:t.licenseUrl}||g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|{target:"_blank",id:"version",text:`v${e.version} (${e.commit})`,url:i?"https://github.com/grafana/grafana/blob/main/CHANGELOG.md":void 0}||g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|{target:"_blank",id:"updateVersion",text:"New version available!",icon:"download-alt",url:"https://grafana.com/grafana/download?utm_source=grafana_footer"}||g' {} \;

RUN echo " #mega-menu-toggle { display: none !important; } .css-xv13ed { display: none !important; } .css-qlgu59 { display: none !important; } .css-adfkf4 { display: none !important; } .css-zanmp0 { display: none !important; } .css-15t8ss1 { display: none !important; } .css-a7i72f-toolbar-button { display: none !important; } .css-18j6u6t { display: none !important; }" >> /usr/share/grafana/public/build/grafana.light.bbe69ddb3979b7904078.css
RUN echo " #mega-menu-toggle { display: none !important; } .css-xv13ed { display: none !important; } .css-qlgu59 { display: none !important; } .css-adfkf4 { display: none !important; } .css-zanmp0 { display: none !important; } .css-15t8ss1 { display: none !important; } .css-a7i72f-toolbar-button { display: none !important; } .css-18j6u6t { display: none !important; }" >> /usr/share/grafana/public/build/grafana.dark.170498723865582cad9d.css

RUN mkdir -p /etc/grafana/dashboards
RUN chown grafana:root /etc/grafana/dashboards

COPY --chown=grafana:root ./grafana/provisioning/datasources/metrics.yaml /etc/grafana/provisioning/datasources/
COPY --chown=grafana:root ./grafana/provisioning/dashboards/alces-dashboards.yaml /etc/grafana/provisioning/dashboards/

USER grafana
