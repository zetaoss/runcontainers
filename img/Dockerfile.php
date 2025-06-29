FROM composer AS builder
RUN set -eux \
    && composer require \
    simplehtmldom/simplehtmldom:2.0-RC2 \
    laravel/framework:^11.35.1

FROM php:8.2-cli
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
