# The CI builds one image per entry in versions.json and passes the entry as BASE_TAG.
# The default below only serves local builds without --build-arg.
ARG BASE_TAG=1.13.5-php8.5.12-trixie@sha256:7e73a27eb7712a5b4073b92f8f0dec91e9400138604b76cc791589faaa6a639c

FROM dunglas/frankenphp:${BASE_TAG}

# This list mirrors the default extension set of the FrankenPHP static build (craft.yml upstream).
# Extensions that the official Docker image already ships are left out.
RUN install-php-extensions \
    amqp \
    apcu \
    ast \
    bcmath \
    brotli \
    bz2 \
    calendar \
    dba \
    exif \
    ftp \
    gd \
    gettext \
    gmp \
    igbinary \
    imagick \
    intl \
    ldap \
    lz4 \
    memcached \
    mysqli \
    parallel \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    protobuf \
    redis \
    shmop \
    soap \
    sockets \
    ssh2 \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xlswriter \
    xsl \
    yaml \
    zip \
    zstd

# Run as www-data. The binary loses the capability to bind ports below 1024,
# so the server listens on 8080 by default. Set SERVER_NAME to change the address.
# /var/www is the home of www-data and does not exist in the base image.
RUN setcap -r /usr/local/bin/frankenphp \
    && mkdir -p /var/www \
    && chown -R www-data:www-data /app /config /data /var/www

ENV SERVER_NAME=:8080
EXPOSE 8080
USER www-data
