# ================================
# 1 — Build des assets Vite
# ================================
FROM node:18 AS nodebuilder

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install

COPY . .
RUN pnpm run build


# ================================
# 2 — Build Laravel (PHP-FPM)
# ================================
FROM php:8.2-fpm AS phpbuilder

RUN apt-get update && apt-get install -y \
    zip unzip curl git libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .
COPY --from=nodebuilder /app/public/build ./public/build

RUN composer install --no-dev --optimize-autoloader
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache


# ================================
# 3 — Final : PHP-FPM + Nginx
# ================================
FROM nginx:alpine

COPY --from=phpbuilder /var/www/html /var/www/html

# Copie du fichier Nginx
COPY ./docker/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]