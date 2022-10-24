FROM nginx:1.19

RUN apt-get update && apt-get install -y --no-install-recommends \
        vim \
        nano \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN touch /var/run/nginx.pid; \
    mkdir /sock; \
    rm  -f /etc/nginx/conf.d/default.conf; \
    mkdir -p /var/www/html

COPY ./config/nginx.conf /etc/nginx/
COPY ./config/magento.conf /etc/nginx/conf.d/

EXPOSE 80

VOLUME /var/www

WORKDIR /var/www/html
