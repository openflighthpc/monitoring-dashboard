FROM docker.io/ruby:3.1.2

RUN apt-get update
RUN apt-get install -y snmp pdsh

RUN git clone https://github.com/openflighthpc/power-exporter.git
WORKDIR /power-exporter/power-exporter
RUN mkdir -p /etc/power-exporter/etc
RUN mkdir -p /var/log/power-exporter

RUN gem install bundler
RUN bundle install

ENTRYPOINT ["ruby", "/power-exporter/power-exporter/bin/exporter.rb"]
