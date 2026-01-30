FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required by Revive Ad Server
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    intl \
    mbstring \
    mysqli \
    pdo \
    pdo_mysql \
    pcntl \
    xml \
    zip \
    gd \
    opcache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set recommended PHP settings for Revive Ad Server
RUN { \
    echo 'memory_limit = 256M'; \
    echo 'upload_max_filesize = 20M'; \
    echo 'post_max_size = 20M'; \
    echo 'max_execution_time = 300'; \
    echo 'date.timezone = UTC'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.memory_consumption = 128'; \
    echo 'opcache.interned_strings_buffer = 8'; \
    echo 'opcache.max_accelerated_files = 10000'; \
    } > /usr/local/etc/php/conf.d/revive-adserver.ini

# Download and extract Revive Ad Server
WORKDIR /tmp
RUN wget https://github.com/revive-adserver/revive-adserver/releases/download/v6.0.5/revive-adserver-6.0.5.zip \
    && unzip revive-adserver-6.0.5.zip \
    && rm -rf /var/www/html/* \
    && cp -r revive-adserver-6.0.5/* /var/www/html/ \
    && rm -rf /tmp/revive-adserver-6.0.5 revive-adserver-6.0.5.zip

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create var directory with proper permissions
RUN mkdir -p /var/www/html/var \
    && chown -R www-data:www-data /var/www/html/var \
    && chmod -R 775 /var/www/html/var

WORKDIR /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
