FROM php:7.4

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Confirm php version
RUN php -v

RUN apt-get -y update && apt-get -y install \
gosu \
unzip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer self-update
RUN composer --version

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
