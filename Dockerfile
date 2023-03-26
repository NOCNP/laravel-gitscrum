# Base Image
FROM php:7.4-apache

# Install Required Libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    zip \
    unzip \
    libmcrypt-dev \
    libpq-dev \
    libzip-dev && \
    rm -rf /var/lib/apt/lists/*

# Install PHP Extensions
RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install zip && \
    docker-php-ext-install mysqli

# Enable Apache Mod Rewrite
RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set Working Directory
WORKDIR /var/www/html

# Copy GitScrum Project Files
COPY . .

# Install Dependencies
RUN composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction

# Copy Environment Configuration
COPY .env.example .env

# Generate Application Key
RUN php artisan key:generate

# Set Permissions for Storage and Bootstrap Cache
RUN chmod -R 777 storage bootstrap/cache

# Expose Port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
