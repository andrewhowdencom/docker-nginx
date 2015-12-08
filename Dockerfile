# Usage: As part of a kubernetes pod
# Much of this file was derived from https://github.com/dockerfile/nginx/blob/master/Dockerfile

FROM debian:jessie

MAINTAINER littleman.co <support@littleman.co> 

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.7-1~jessie

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ENV CONFIGURATION_VERSION=1.1.0

# Update the configuration
RUN rm -rf /etc/nginx
ADD etc/nginx /etc/nginx 

# Bind to the host file system for better performance. See https://github.com/nginxinc/docker-nginx/issues/19
VOLUME ["/var/cache/nginx"]

VOLUME ["/etc/nginx/sites-enabled/", "/etc/ssl/", "/etc/nginx/conf.d/", "/var/log/nginx/", "/var/www/"]

EXPOSE 80 443

# Run with custom configuration path
CMD ["nginx", "-g", "daemon off;"]
