FROM victoriametrics/victoria-metrics:v1.95.1
RUN mkdir -p /etc/victoria-metrics/{configs,targets}
COPY ./vmetrics/prometheus.yml /etc/victoria-metrics/
