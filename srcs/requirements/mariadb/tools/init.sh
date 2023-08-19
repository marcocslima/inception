#!/bin/bash

# Verify enviroment vaiables
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$WORDPRESS_DATABASE" ] || [ -z "$WP_ADMIN_USER" ] || [ -z "$WP_ADMIN_PASSWORD" ]; then
    echo "Error: Some enviroment variables does not defined."
    exit 1
fi

# Start MariaDB server
mysqld_safe --skip-syslog &

# Wait MariaDB server to be ready
while ! mysqladmin ping -hlocalhost --silent; do
    sleep 1
done

# Verify is there database already
if ! mysql -e "USE $WORDPRESS_DATABASE;";
then
    # Create database and user
    mysql -e "CREATE DATABASE $WORDPRESS_DATABASE;"
    mysql -e "CREATE USER '$WP_ADMIN_USER'@'%' IDENTIFIED BY '$WP_ADMIN_PASSWORD';"
    mysql -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE.* TO '$WP_ADMIN_USER'@'%';"
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
#exec mysqld_safe
exec mariadbd
