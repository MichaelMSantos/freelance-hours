FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    curl

RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

RUN a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .


RUN composer install --no-scripts --no-autoloader

RUN composer dump-autoload --optimize


RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache


EXPOSE 80

CMD ["apache2-foreground"]
