#!/bin/bash

if [! -d "/var/lib/mysql/$WORDPRESS_DATABASE"]
then

/etc/init.d/mariadb start
mysql -u root -p$ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DATABASE; CREATE USER '$WORDPRESS_USER'@'%' IDENTIFIED BY '$WORDPRESS_PASSWORD'; GRANT ALL ON $WORDPRESS_DATABASE.* TO '$WORDPRESS_USER'@'%' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
mysql -u root -p$ROOT_PASSWORD $WORDPRESS_DATABASE < /tmp/dump.sql
mysql -u root -p$ROOT_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';"
mysql -u root -p$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}' WITH GRANT OPTION;"
mysql -u root -p$ROOT_PASSWORD -e "FLUSH PRIVILEGES"
sed -i "s/password =/password = ${ROOT_PASSWORD}/g" /etc/mysql/debian.cnf
/etc/inid.d/mariadb stop

fi

exec "$@"