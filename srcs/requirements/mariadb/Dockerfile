FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install \
    mariadb-server -y \
    nano

RUN rm /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chown -R mysql:mysql /var/lib/mysql

COPY ./tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["init.sh"]

CMD ["/usr/bin/mysqld_safe"]