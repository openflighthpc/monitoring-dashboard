FROM ubuntu:20.04

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt install -y nginx libnginx-mod-http-auth-pam sssd

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

RUN printf "\n\
auth required pam_sss.so\n\
account required pam_sss.so\n\
password required pam_sss.so\n\
session required pam_sss.so\n\
" > /etc/pam.d/dashboard

RUN mkdir -p /etc/nginx/certs
COPY ./nginx/reverse-proxy.conf /etc/nginx/sites-available/default

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
