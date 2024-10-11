# Use a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Atualizar e instalar dependências necessárias
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

# Instalar extensões PHP necessárias para o Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Habilitar módulos Apache necessários
RUN a2enmod rewrite

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho para o Laravel
WORKDIR /var/www/html

# Copiar os arquivos do projeto Laravel para o container
COPY . .

# Criar diretórios de cache e ajustar permissões
RUN mkdir -p /var/www/html/storage/framework/{cache,sessions,views} \
    && mkdir -p /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/bootstrap/cache

# Instalar dependências do Composer sem rodar scripts pós-instalação
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-scripts --no-interaction --prefer-dist

# Gerar o autoloader otimizado
RUN COMPOSER_ALLOW_SUPERUSER=1 composer dump-autoload --optimize --no-interaction

# Expor a porta 80 para o servidor web
EXPOSE 80

# Iniciar o servidor Apache
CMD ["apache2-foreground"]
