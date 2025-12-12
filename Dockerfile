
# Utiliser une image complète pour le build (y compris Node/NPM)
# ==============================
FROM php:8.2-fpm AS base

# 1. Installer les dépendances système (y compris l'outil "wait-for-it" si nécessaire)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libzip-dev \
    # Nodejs et npm seront installés via un autre RUN pour simplifier
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# 2. Installer Node.js et NPM (Mise à jour de l'installation pour éviter les problèmes de paquets)
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 3. Ajouter Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# 4. Copier le code (seulement le strict nécessaire pour minimiser la taille de l'image)
COPY composer.* ./
COPY package.json ./
COPY package-lock.json ./
COPY vite.config.js ./
# ... autres fichiers de config essentiels ...

# 5. Installer les dépendances PHP et Node
RUN composer install --no-dev --optimize-autoloader
RUN npm install

# Copier le reste du code
COPY . .

# 6. Corriger le problème de git ownership
RUN git config --global --add safe.directory /var/www/html

# 7. Optimisations Laravel et build du frontend
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
RUN npm run build


# ==============================
# Étape 2 : Production (Image Finale Légère)
# Utiliser une image de base FPM plus simple pour l'exécution
# ==============================
FROM php:8.2-fpm

# Définir le répertoire de travail
WORKDIR /var/www/html

# 8. Copier uniquement les fichiers nécessaires depuis l'étape de construction
COPY --from=base /var/www/html /var/www/html

# 9. Correction CRITIQUE des permissions
# S'assurer que les fichiers appartiennent à l'utilisateur PHP-FPM (www-data)
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 storage bootstrap/cache

# 10. Mise à jour de la commande de démarrage
# S'assurer que php-fpm écoute sur 0.0.0.0 (toutes les interfaces)
# Dokploy (ou Nginx) pourra ainsi se connecter.
# L'EXPOSE 9000 est inclus dans l'image de base FPM par défaut.
# Si vous utilisez un fichier de configuration PHP-FPM personnalisé, assurez-vous qu'il écoute sur 0.0.0.0:9000.
CMD ["php-fpm"]