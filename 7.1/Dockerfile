FROM braydeejohnson/php:7.1

MAINTAINER "Braydee Johnson" <braydee@braydeejohnson.com>

RUN sed -i "s/jessie main/jessie main contrib non-free/" /etc/apt/sources.list
RUN echo "deb http://http.debian.net/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update -y && \
	apt-get install -y \
	ffmpeg \
	zip \
	unzip \
	supervisor \
	&& apt-get install -y \
	php7.1-fpm \
    nginx \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/laravel /etc/nginx/sites-available/laravel

RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel && \
    rm /etc/nginx/sites-enabled/default

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /data && \
    mkdir -p /logs

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i "/listen = .*/c\listen = [::]:9000" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/pid = .*/c\;pid = /run/php/php7.1-fpm.pid" /etc/php/7.1/fpm/php-fpm.conf  && \
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i '/^;env\[TEMP\] = .*/aenv[DB_PORT_3306_TCP_ADDR] = $DB_PORT_3306_TCP_ADDR' /etc/php/7.1/fpm/pool.d/www.conf

ENV XDEBUG_REMOTE_HOST localhost
ENV XDEBUG_REMOTE_KEY docker
ENV XDEBUG_REMOTE_PORT 9000
ENV VIRTUAL_HOST localhost

RUN echo "xdebug.max_nesting_level = 1024" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_handler=dbgp" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_port=$XDEBUG_REMOTE_PORT" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_autostart=1" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_connect_back=0" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.idekey=$XDEBUG_REMOTE_KEY" >> /etc/php/7.1/mods-available/xdebug.ini
RUN echo "xdebug.remote_host=$XDEBUG_REMOTE_HOST" >> /etc/php/7.1/mods-available/xdebug.ini

RUN echo "extension=mongodb.so" > /etc/php/7.1/fpm/conf.d/20-mongodb.ini && \
	echo "extension=mongodb.so" > /etc/php/7.1/cli/conf.d/20-mongodb.ini && \
	echo "extension=mongodb.so" > /etc/php/7.1/mods-available/mongodb.ini

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-container.sh /usr/sbin/start-container
RUN chmod +x /usr/sbin/start-container

WORKDIR /opt/bin
VOLUME ["/data"]
VOLUME ["/data/logs"]

# PORTS
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/start-container"]