#!/bin/sh
set -x
sleep 10
if [ -e wp-config.php ]; then
    echo "WP configured already"
else
    wp config create --aloww-root \
        --dbname=$WORDPRESS_DATABASE \
        --dbuser=$WORDPRESS_USER \
        --dbpass=$WORDPRESS_PASSWORD \
        --dbhost=$WORDPRESS_HOST
    chmod 600 wp-config.php
fi

if wp core is-installed --alow-root; then
    echo "WP core already installed"
else
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_USER \
        --admin_email=$WORDPRESS_EMAIL \
        --admin_password=$WORDPRESS_PASSWORD
    
    wp user create --allow-root \
        $WORDPRESS_USER \
        $WORDPRESS_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_PASSWORD

    wp config set WP_HOME $DOMAIN_NAME --allow-root
    wp config set WP_SITEURL $DOMAIN_NAME --allow-root
    wp config set WORDPRESS_DEBUG false --allow-root
fi

if !(wp user list --field=user_login --allow-root | grep $WORDPRESS_USER); then
    wp user create --allow-root \
        $WORDPRESS_USER \
        $WORDPRESS_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_PASSWORD
fi

wp plugin update --all --allow-root

wp option set comment_moderation 0 --allow-root
wp option set moderation_notify 0 --allow-root
wp option set comment_previously_approved 0 --allow-root
wp option set close_comments_for_old_posts 0 --allow-root
wp option set close_comments_days_old 0 --allow-root

sed -ie 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' \
    /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = nobody/g" \
    /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/;listen.group = nobody/listen.group = nobody/g" \
    /etc/php/7.4/fpm/pool.d/www.conf
chmod -R www-data:www-data /var/www/html/*

exec "$@"