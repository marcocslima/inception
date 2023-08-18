#!/bin/sh

if [ -e wp-config.php ]; then
    echo "Wordpress has been running alredy!.."
else
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
fi

wp option update blogdescription $WP_SUB_TITLE --allow-root
wp plugin uninstall akismet hello --allow-root
wp plugin install redis-cache --allow-root

wp plugin update --all --allow-root
wp redis enable --all --allow-root

chown -R www-data:www-data /var/www/html/*

exec "$@"