FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip unzip curl git libpq-dev libzip-dev nodejs npm \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:clear
RUN php artisan view:cache || true

RUN npm install
RUN npm run build

EXPOSE 9000

CMD ["php-fpm"]
