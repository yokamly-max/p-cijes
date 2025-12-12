# ==============================
# ÉTAPE 1 : BUILD (Construction)
# ==============================
FROM php:8.2-fpm AS build

# Installer les dépendances système (Git, Curl, Unzip, libs PHP)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libzip-dev \
    gnupg \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Installer Node.js 20 et NPM
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Ajouter Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# --- COPIE DES FICHIERS MINIMAUX POUR COMPOSER/ARTISAN ET VITE ---

# Fichiers de configuration
COPY composer.* ./
COPY package.json ./
COPY package-lock.json ./
COPY vite.config.js ./
COPY artisan ./

# Dossiers critiques :
COPY app/ ./app/
COPY bootstrap/ ./bootstrap/
COPY config/ ./config/
COPY routes/ ./routes/
COPY resources/ ./resources/
COPY database/ ./database/  # Ajout critique pour les migrations/Artisan

# --- FIN DE COPIE CRITIQUE ---


# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Installer les dépendances Node et compiler le frontend
RUN npm install
RUN npm run build

# Copier le reste du code source
COPY . .

# Corriger le problème de git ownership
RUN git config --global --add safe.directory /var/www/html

# Créer les dossiers de stockage si absents (pour les permissions)
RUN mkdir -p storage/framework/sessions \
    && mkdir -p storage/framework/views \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/logs

# Nettoyage et Optimisations Laravel (Caches)
# Nous utilisons APP_ENV=production par défaut pour le cache
RUN sed -i '/^APP_ENV=/c\APP_ENV=production' ./.env
RUN sed -i '/^APP_DEBUG=/c\APP_DEBUG=false' ./.env
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:clear

# ==============================
# ÉTAPE 2 : PRODUCTION (Image Finale Légère)
# ==============================
FROM php:8.2-fpm

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier le code construit (y compris vendor, node_modules, build public)
COPY --from=build /var/www/html /var/www/html

# CRITIQUE : Définir les permissions de l'utilisateur FPM
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port PHP-FPM
EXPOSE 9000

# Commande de lancement par défaut
CMD ["php-fpm"]