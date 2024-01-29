# seleccionado una version estable de la imagen
FROM php:7.4-apache
# copiando el script php que hace consulta a la bd
# mysql del stack
##COPY php_code/ /var/www/html/
# instalando librerias de php-mysql para poder 
# realizar las consultas a la bd
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar dependencias de Redis
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libonig-dev \
        unzip \
        tar \
    && rm -rf /var/lib/apt/lists/*

# Descargar y compilar la extensión Redis
ENV REDIS_VERSION 5.3.4
RUN mkdir -p /usr/src/php/ext/redis
RUN curl -L -o redis.tar.gz https://github.com/phpredis/phpredis/archive/${REDIS_VERSION}.tar.gz \
    && tar xfz redis.tar.gz \
    && rm -r redis.tar.gz 
RUN mv phpredis-${REDIS_VERSION} /usr/src/php/ext/redis

# Habilitar la extensión Redis
RUN docker-php-ext-install redis/phpredis-${REDIS_VERSION}

# este dockerfile servira punto de creacion de la
# imagen "php7.4:v3" que se usara posteriormente 
# en el Dockercompose que del stack 

# desde la ubicacion de este archivo ejecutar:
# docker build -t php7.4:v1 .

# garantizar que se encuentre es fichero "index.php"
# en la carpeta "php_code"



