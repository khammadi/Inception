#!/bin/bash

install_wp_cli_and_setup_permissions() {
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    local wp_dir="/var/www/wordpress"
    chown -R www-data:www-data "$wp_dir"
    chmod -R 755 "$wp_dir"
}

ping_mariadb_and_wait() {
    local start_time=$(date +%s)
    local end_time=$((start_time + 20))

    while [ $(date +%s) -lt $end_time ]; do
        nc -zv mariadb 3306 > /dev/null
        if [ $? -eq 0 ]; then
            echo "[****** MARIADB IS RUNNING ******]"
            return 0
        else
            echo "[****** WAITING FOR MARIADB TO START ******]"
            sleep 1
        fi
    done

    echo "[***** MARIADB IS NOT RESPONDING ******]"
    return 1
}

install_and_configure_wordpress() {
    local wp_dir="/var/www/wordpress"
    cd "$wp_dir" || exit 1
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL" --allow-root
    wp user create "$WP_USER_NAME" "$WP_USR_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
}

configure_php_fpm() {
    sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
    mkdir -p /run/php
    /usr/sbin/php-fpm7.4 -F
}

install_wp_cli_and_setup_permissions
ping_mariadb_and_wait

if [ $? -eq 0 ]; then
    install_and_configure_wordpress
else
    echo "Failed to connect to MariaDB. Exiting."
    exit 1
fi

configure_php_fpm