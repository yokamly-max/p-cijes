# ==============================
# ÉTAPE 1 : BUILD (Construction)
# Utilise une image complète pour installer les dépendances et compiler.
# ==============================
FROM php:8.2-fpm AS build

# Installer les dépendances système (Git, Curl, Unzip, libs PHP)
# Ajout de gnupg pour l'installation de Node.js
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libzip-dev \
    gnupg \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Installer Node.js 20 et NPM (pour le build Vite/frontend)
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Ajouter Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers critiques NÉCESSAIRES avant l'installation des dépendances
# CORRECTION du 'Could not open input file: artisan'
COPY composer.* ./
COPY package.json ./
COPY package-lock.json ./
COPY vite.config.js ./
COPY artisan ./
# Ajoutez d'autres fichiers de configuration nécessaires ici (ex: tailwind.config.js si utilisé par vite.config.js)

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Installer les dépendances Node et compiler le frontend
RUN npm install
RUN npm run build

# Copier le reste du code source
COPY . .

# Corriger le problème de git ownership qui peut affecter Composer/Artisan
RUN git config --global --add safe.directory /var/www/html

# Nettoyage et Optimisations Laravel
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:clear
# Note: Ne pas cacher les vues si vous faites des modifications fréquentes en dev.
# RUN php artisan view:cache 

# ==============================
# ÉTAPE 2 : PRODUCTION (Image Finale Légère)
# Basée sur l'image fpm standard
# ==============================
FROM php:8.2-fpm

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier le code construit depuis l'étape 'build'
COPY --from=build /var/www/html /var/www/html

# CRITIQUE pour le 502 : Définir les permissions de l'utilisateur FPM
# L'utilisateur www-data doit être propriétaire des dossiers de cache et de stockage.
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port PHP-FPM
EXPOSE 9000

# Commande de lancement
# Le 'php-fpm' va démarrer et se lier au port 9000, prêt à recevoir les requêtes
# du proxy de Dokploy.
CMD ["php-fpm"]