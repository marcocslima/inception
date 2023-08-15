FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install nginx -y \
        && apt install nano -y && apt install curl -y

RUN mkdir -p /etc/nginx/ssl

RUN apt install openssl -y

RUN openssl req -x509 -nodes \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=BR/ST=SP/L=SP/O=42sp/CN=mcesar-d.42.fr/UID=mcesar-d"

RUN mkdir -p /var/run/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]