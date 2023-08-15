FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    gettext \
    php7.4 php7.4-fpm php7.4-cli \
    wget curl procps \
    php7.4-curl php7.4-mysql php7.4-mbstring php7.4-xml php7.4-gd \
    sendmail mariadb-client gettext-base \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/list/* \
    && mkdir /run/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        --output-document=/usr/local/bin/wp \
        && chmod +x /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/html/wordpress \
    && chmod -R 755 /var/www/html/

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod 755 /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html/

RUN wp core download --allow-root

COPY tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT [ "init.sh" ]

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4", "-F", "-R"]