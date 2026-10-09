ARG PHP_VERSION=8.4

FROM composer AS builder
ARG PHP_VERSION
# Resolve dependencies for the runtime PHP, not the PHP in the composer image.
RUN set -eux \
    && composer config --global platform.php ${PHP_VERSION} \
    && composer require \
    simplehtmldom/simplehtmldom:2.0-RC2 \
    laravel/framework:^12.0

FROM php:${PHP_VERSION}-cli
RUN set -eux \
    && useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev \
    time \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd
COPY --from=builder /app/vendor /home/user01/vendor

USER user01
WORKDIR /home/user01/
