FROM docker.io/nginx:alpine
RUN mkdir -p /etc/nginx/certs
COPY ./nginx/reverse-proxy-noauth.conf /etc/nginx/conf.d/default.conf
