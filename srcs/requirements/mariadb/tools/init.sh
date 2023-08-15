#!/bin/bash

# Verify enviroment vaiables
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$WORDPRESS_DATABASE" ] || [ -z "$WORDPRESS_USER" ] || [ -z "$WORDPRESS_PASSWORD" ]; then
    echo "Erro: As variáveis de ambiente não estão definidas corretamente."
    exit 1
fi

# Start MariaDB server
mysqld_safe --skip-syslog &

# Wait MariaDB server to be ready
while ! mysqladmin ping -hlocalhost --silent; do
    sleep 1
done

# Verify is there database already
if ! mysql -e "USE $WORDPRESS_DATABASE;" > /dev/null 2>&1; then
    # Create database and user
    mysql -e "CREATE DATABASE $WORDPRESS_DATABASE;"
    mysql -e "CREATE USER '$WORDPRESS_USER'@'%' IDENTIFIED BY '$WORDPRESS_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE.* TO '$WORDPRESS_USER'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "Database has been sucess created."
else
    echo "Database '$WORDPRESS_DATABASE' exists already."
fi

# Stop MariaDB server
mysqladmin shutdown

# Wait server complitely down
while mysqladmin ping -hlocalhost --silent; do
    sleep 1
done

# Start MariaDB server
exec mysqld_safe
