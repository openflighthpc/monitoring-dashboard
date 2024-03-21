FROM nginx:alpine
RUN mkdir -p /etc/nginx/certs
COPY ./nginx/reverse-proxy.conf /etc/nginx/conf.d/default.conf
