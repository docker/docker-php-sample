# syntax=docker/dockerfile:1

FROM php:8.2-apache

WORKDIR /var/www/html

# Install Composer by copying its binary from the official composer image
COPY --from=composer:lts /usr/bin/composer /usr/bin/composer

# Copy dependency manifests first so Docker can cache this layer
# (only re-runs composer install if these files change)
COPY composer.json composer.lock ./

# Install PHP dependencies (production only, no dev packages)
RUN composer install --no-dev --no-interaction --optimize-autoloader

# Use production php.ini defaults
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy the rest of the application source
COPY ./src /var/www/html

# Make sure the web server user owns the files
RUN chown -R www-data:www-data /var/www/html

USER www-data
