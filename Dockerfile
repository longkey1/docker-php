FROM php:latest

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Install gosu
RUN apt-get -y update && apt-get -y install gosu

# Make working directory
ENV WORK_DIR=/work
RUN mkdir ${WORK_DIR}

# Set Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Confirm php version
RUN php -v

# Install zip extension
RUN apt-get -y update && apt-get -y install libzip-dev
RUN docker-php-ext-install zip

# Install composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer2
RUN ln -s /usr/bin/composer2 /usr/bin/composer

# Confirm composer version
RUN composer --version
RUN composer1 --version
RUN composer2 --version

