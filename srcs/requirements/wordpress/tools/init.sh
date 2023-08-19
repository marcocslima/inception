#!/bin/sh

if [ -e wp-config.php ]; then
    echo "Wordpress has been running alredy!.."
else
    rm -rf *.*

    wp core download --allow-root

    wp config create --allow-root \
                        --dbhost=$WORDPRESS_HOSTNAME \
                        --dbname=$WORDPRESS_DATABASE \
                        --dbuser=$WP_ADMIN_USER \
                        --dbpass=$WP_ADMIN_PASSWORD

    wp config set --allow-root WP_HOME $DOMAIN_NAME
    wp config set --allow-root WP_SITEURL $DOMAIN_NAME

    wp core install --allow-root \
                        --url=$DOMAIN_NAME \
                        --title=$WP_TITLE \
                        --admin_user=$WP_ADMIN_USER \
                        --admin_password=$WP_ADMIN_PASSWORD \
                        --admin_email=$WP_ADMIN_EMAIL \
                        --skip-email
fi

if !(wp user list --field=user_login --allow-root | grep $WORDPRESS_USER); then
    wp user create --allow-root \
        $WORDPRESS_USER \
        $WORDPRESS_USER_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_PASSWORD
fi

wp plugin uninstall akismet hello --allow-root
wp plugin update --all --allow-root

chown -R www-data:www-data /var/www/html/*

exec "$@"