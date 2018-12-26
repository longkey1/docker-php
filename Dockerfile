FROM php:latest

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Confirm php version
RUN php -v

# Install composer
RUN apt-get -y update && apt-get -y install unzip
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer self-update
