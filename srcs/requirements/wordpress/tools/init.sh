#!/bin/sh

rm -rf *.*

wp core download --allow-root

wp config create --allow-root \
                    --dbhost=$WORDPRESS_HOSTNAME \
                    --dbname=$WORDPRESS_DATABASE \
                    --dbuser=$WORDPRESS_USER \
                    --dbpass=$WORDPRESS_PASSWORD

wp config set --allow-root WP_HOME $DOMAIN_NAME
wp config set --allow-root WP_SITEURL $DOMAIN_NAME

wp core install --allow-root \
                    --url=$DOMAIN_NAME \
                    --title="INCEPTION" \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --skip-email


exec "$@"