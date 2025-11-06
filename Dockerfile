FROM php:8.4

# Définir le répertoire de travail
WORKDIR /project

# Copier le projet Laravel dans l'image
COPY app1 .

# Installer les dépendances nécessaires

RUN apt-get update && apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libpq-dev\
		zip unzip \
		&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
		&& php composer-setup.php \
		&& php -r "unlink('composer-setup.php');" \
		&& mv composer.phar /usr/local/bin/composer \
		&& docker-php-ext-install pdo  pgsql  pdo_pgsql \
                && composer install 




EXPOSE 8000

RUN adduser www\
  && usermod -aG www www

RUN  chmod u+x /project/entrypoint.sh \
	 && php artisan key:gen 
RUN chown -R www:www  /project \
               && chmod -R 775 /project/storage
	 
USER  www
#ENTRYPOINT [ "sleep ","10000000000000000000000000000000000000000000000000000000"]

# Lancer le serveur Laravel
#ENTRYPOINT ["php","artisan", "serve"]

ENTRYPOINT ["php","artisan", "serve", "--host", "0.0.0.0"]

