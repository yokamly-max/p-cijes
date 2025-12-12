# Utiliser PHP 8.2 FPM
FROM php:8.2-fpm

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    zip unzip curl git libpq-dev libzip-dev npm \
    && docker-php-ext-install pdo pdo_mysql zip

# Copier Composer depuis l'image officielle
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers de l'application
COPY . .

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Générer la clé Laravel et cacher config / routes / vues
RUN php artisan key:generate --force
RUN php artisan config:cache || echo "Warning: config cache failed"
RUN php artisan route:cache || echo "Warning: route cache failed"
RUN php artisan view:cache || echo "Warning: view cache failed"

# Installer les dépendances Node.js et builder le front
RUN npm install
RUN npm run build

# Exposer le port (utile si FPM n'est pas derrière Nginx)
EXPOSE 9000

# Ne pas utiliser 'php artisan serve' en prod, FPM s'en charge
CMD ["php-fpm"]
