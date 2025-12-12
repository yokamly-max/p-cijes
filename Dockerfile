# Étape 1 : PHP-FPM
FROM php:8.2-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    zip unzip curl git libpq-dev libzip-dev nodejs npm \
    && docker-php-ext-install pdo pdo_mysql zip

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tout le projet
COPY . .

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Générer la clé Laravel et cacher config/routes/views
RUN php artisan key:generate --force
RUN php artisan config:cache || true
RUN php artisan route:clear
RUN php artisan view:cache || true

# Installer les dépendances front-end et builder Vite
RUN npm install
RUN npm run build

# Exposer le port FPM
EXPOSE 9000

# Lancer PHP-FPM
CMD ["php-fpm"]
