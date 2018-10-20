#!/bin/bash

# Update Xdebug host
sed -i "s|xdebug.remote_host.*|xdebug.remote_host = ${XDEBUG_REMOTE_HOST}|" /etc/php/7.1/mods-available/xdebug.ini
sed -i "s|xdebug.idekey.*|xdebug.idekey = ${XDEBUG_REMOTE_KEY}|" /etc/php/7.1/mods-available/xdebug.ini
sed -i "s|xdebug.remote_port.*|xdebug.remote_port = ${XDEBUG_REMOTE_PORT}|" /etc/php/7.1/mods-available/xdebug.ini

# Update Nginx conf
sed -i "s|server_name.*|server_name ${VIRTUAL_HOST};|" /etc/nginx/sites-available/laravel

#Run supervisord in Foreground
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf