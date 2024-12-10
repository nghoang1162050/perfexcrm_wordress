FROM php:8.2.27RC1-apache

# EXPOSE 8080

# Install system dependencies and PHP extensions
RUN apt-get update -y && apt-get install -y \
    gcc make autoconf libc-dev pkg-config \
    apt-utils build-essential libpng-dev libc-client-dev libkrb5-dev libzip-dev libssl-dev zip tree htop --no-install-recommends

RUN apt-get clean && rm -r /var/lib/apt/lists/*

# Installing php Dependencies 
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-install mysqli gd zip

RUN a2enmod rewrite
COPY . /var/www/html/

# Configuring Ownerships and permissions
RUN chown -R www-data:www-data /var/www/html/

RUN chmod 755 /var/www/html/uploads/
RUN chmod 755 /var/www/html/application/config/
RUN chmod 755 /var/www/html/application/config/config.php
RUN chmod 755 /var/www/html/application/config/app-config-sample.php
RUN chmod 755 /var/www/html/temp/