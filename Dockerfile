FROM php:8.0

# Fix frontend not set error
ARG DEBIAN_FRONTEND=noninteractive

# Update apt packages
RUN apt-get -y update

# Install gosu
RUN apt-get -y install gosu

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
RUN apt-get -y install libzip-dev
RUN docker-php-ext-install zip

# Install composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer1
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer2
RUN ln -s /usr/bin/composer2 /usr/bin/composer

# Confirm composer version
RUN composer --version
RUN composer1 --version
RUN composer2 --version

# Install gnupg wget for installing phive
RUN apt-get -y install gnupg wget

# Install phive
RUN wget -O phive.phar https://phar.io/releases/phive.phar
RUN wget -O phive.phar.asc https://phar.io/releases/phive.phar.asc
RUN gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x9D8A98B29B2D5D79
RUN gpg --verify phive.phar.asc phive.phar
RUN chmod +x phive.phar
RUN mv phive.phar /usr/local/bin/phive

# Confirm phive version
RUN phive --version
