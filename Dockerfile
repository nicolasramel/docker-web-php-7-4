FROM php:7.4-apache

RUN apt-get -yqq update
RUN apt-get -yqq install exiftool \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libpng-dev \
    libzip-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install gd

RUN docker-php-ext-configure exif
RUN docker-php-ext-install exif
RUN docker-php-ext-enable exif

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY 20-web.ini /usr/local/etc/php/conf.d/20-web.ini
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html

CMD ["apache2-foreground"]