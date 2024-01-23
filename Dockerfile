FROM php:8-apache

RUN apt-get update && \
    apt-get install -y libzip-dev zip unzip && \
    docker-php-ext-install pdo_mysql zip

RUN a2enmod rewrite

COPY docker/apache-config.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

COPY . .

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN composer install --optimize-autoloader --no-dev
RUN chmod 755 -R /var/www/html
RUN composer install --optimize-autoloader --no-dev

RUN chown -R www-data:www-data /var/www/html/bootstrap/cache
RUN chmod 777 -R storage/

EXPOSE 80

CMD ["apache2-foreground"]
