FROM php:8.3-fpm

# Actualización del sistema y herramientas básicas
RUN apt-get update -y && apt-get upgrade -y && apt-get install git nano unzip libssl-dev -y

# Descargar e instalar Composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php

# Instalar y habilitar la extensión MongoDB
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/php.ini

# Verificar e instalar Composer
RUN HASH=$(curl -sS https://composer.github.io/installer.sig) && \
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('/tmp/composer-setup.php'); exit(1); } echo PHP_EOL;" && \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Instalar extensiones de PHP necesarias
RUN docker-php-ext-install pdo pdo_mysql

