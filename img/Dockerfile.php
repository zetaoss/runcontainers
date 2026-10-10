FROM composer:2.10.3 AS builder
# Resolve dependencies for the runtime PHP, not the PHP in the composer image: keep in step with FROM php below.
RUN set -eux \
    && composer config --global platform.php 8.4 \
    && composer require \
    simplehtmldom/simplehtmldom:2.0-RC2 \
    laravel/framework:^12.0

FROM php:8.5-cli
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
