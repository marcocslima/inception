#!/bin/bash

if [! -d "/var/lib/mysql/$WORDPRESS_DATABASE"]
then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

mysqld_safe --datadir=/var/lib/mysql &
sleep 5

mysql --user=root << _EOF_
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD';
FLUSH PRIVILEGES;
_EOF_

chown -R mysql:mysql /var/lib/mysql

mysql --user=root --password=$ROOT_PASSWORD << _EOF_
CREATE DATABASE IF NOT EXISTS $WORDPRESS_DATABASE;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE.* TO '$WORDPRESS_USER'@'%' IDENTIFIED BY '$WORDPRESS_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
_EOF_

mysqladmin -uroot -p$ROOT_PASSWORD shutdown

exec "$@"