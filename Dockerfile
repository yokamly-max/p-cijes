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
# Nous conservons la version 20 pour la compatibilité
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Ajouter Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# --- COPIE DES FICHIERS NÉCESSAIRES POUR COMPOSER/ARTISAN ---
# Ces fichiers sont nécessaires pour que 'composer install' puisse exécuter Laravel's 'package:discover'

# Fichiers de configuration
COPY composer.* ./
COPY package.json ./
COPY package-lock.json ./
COPY vite.config.js ./
COPY artisan ./
COPY .env.example ./.env # IMPORTANT : Copier .env.example pour qu'artisan ne plante pas

# Dossiers critiques :
COPY app/ ./app/              # CORRIGE l'erreur 'AppServiceProvider not found'
COPY bootstrap/ ./bootstrap/  # CORRIGE l'erreur 'app.php not found'
COPY config/ ./config/        # Assure que toutes les configurations sont disponibles (nécessaire pour la plupart des packages)
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

# Nettoyage et Optimisations Laravel
# Nous exécutons ces commandes seulement après avoir copié tout le code (ligne 'COPY . .')
# pour s'assurer que tous les fichiers sont en place pour le caching.
RUN php artisan key:generate --force
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:clear
# RUN php artisan view:cache # Décommenter si vous souhaitez cacher les vues

# ==============================
# ÉTAPE 2 : PRODUCTION (Image Finale Légère)
# Basée sur l'image fpm standard
# ==============================
FROM php:8.2-fpm

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier le code construit (dépendances PHP et frontend) depuis l'étape 'build'
COPY --from=build /var/www/html /var/www/html

# CRITIQUE : Définir les permissions de l'utilisateur FPM
# L'utilisateur www-data doit être propriétaire des dossiers de cache et de stockage.
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port PHP-FPM
EXPOSE 9000

# Commande de lancement par défaut
CMD ["php-fpm"]