FROM debian:12

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=MO/ST=RHAMNA/L=BENGRIR/O=1337/OU=1337/CN=khammadi.42.fr/UID=khammadi"

COPY config/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

CMD ["nginx", "-g", "daemon off;"]
