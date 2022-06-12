FROM nginx:1.21.5-alpine

RUN apk add --no-cache --update

RUN apk add --no-cache --update \
  bash \
  supervisor \
  gcc \
  g++ \
  make \
  php8 \
  php8-apcu \
  php8-bcmath \
  php8-bz2 \
  php8-cgi \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fpm \
  php8-ftp \
  php8-gd \
  php8-iconv \
  php8-json \
  php8-mbstring \
  php8-opcache \
  php8-openssl \
  php8-pcntl \
  php8-pecl-oauth \
  php8-pecl-imagick \
  php8-pdo \
  php8-pdo_mysql \
  php8-phar \
  php8-redis \
  php8-session \
  php8-simplexml \
  php8-tokenizer \
  php8-xdebug \
  php8-xml \
  php8-xmlreader \
  php8-xmlwriter \
  php8-zip \
  php8-zlib \
  php8-fileinfo \
  php8-pear \
  php8-dev \
  composer

RUN ln -s /usr/bin/php8 /usr/bin/php

RUN composer global require laravel/installer

ENV APP_ENV development

COPY ./config/be.supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN sed -i -e 's/\r$//' /etc/supervisor/conf.d/supervisord.conf

RUN sed -i \
        -e 's~^user = nobody$~user = root~' \
	-e 's~^group = nobody$~group = root~' \
	/etc/php8/php-fpm.d/www.conf

RUN rm /etc/nginx/conf.d/default.conf

COPY ./shaft-be /home/shaft/shaft-be
COPY ./be.nginx.conf /etc/nginx/nginx.conf
COPY ./site-enable/api.shaft.conf /etc/nginx/conf.d/api.shaft.conf
COPY ./shaft-be/.env.development /home/shaft/shaft-be/.env


WORKDIR /home/shaft/shaft-be
COPY ./shaft-be/composer.* ./

COPY ./shell/back.run.sh /usr/local/bin/back.run.sh
RUN sed -i -e 's/\r$//' /usr/local/bin/back.run.sh && \
	chmod 0777 /usr/local/bin/back.run.sh

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/back.run.sh" ]