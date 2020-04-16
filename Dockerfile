FROM php:7.3-fpm-buster
MAINTAINER Volodymyr Marynychev <requix@gmail.com>

RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libbz2-dev \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libsodium-dev \
  libssh2-1-dev \
  libxslt1-dev \
  libzip-dev \
  lsof \
  default-mysql-client \
  vim \
  zip

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  intl \
  mbstring \
  mysqli \
  opcache \
  pcntl \
  pdo_mysql \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  xsl \
  zip

RUN groupadd -g 1000 app \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app

RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=1.9.0 --install-dir=/usr/local/bin --filename=composer

COPY ./conf/www.conf /usr/local/etc/php-fpm.d/
RUN rm /usr/local/etc/php-fpm.d/zz-docker.conf

RUN mkdir -p /etc/nginx/html /var/www/html /sock \
  && chown -R app:app /etc/nginx /var/www /usr/local/etc/php/conf.d /sock 

USER app:app

VOLUME /var/www

WORKDIR /var/www/html

CMD ["php-fpm"]

EXPOSE 9001

