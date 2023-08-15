#!/bin/sh

if [ -f ./wp-config.php ]
then
    echo "wordpress already ok"
else
    sed -i "s/username_here/$WORDPRESS_USER/g" wp-config-sample.php
    sed -i "s/password_here/$WORDPRESS_PASSWORD/g" wp-config-sample.php
    sed -i "s/localhost/$WORDPRESS_HOSTNAME/g" wp-config-sample.php
    sed -i "s/database_name_here/$WORDPRESS_DATABASE/g" wp-config-sample.php
    cp wp-config-sample.php wp-config.php
fi

exec "$@"