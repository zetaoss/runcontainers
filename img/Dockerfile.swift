FROM swift:6.0-slim

RUN set -eux \
    && useradd -m -d /home/user01 user01 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    time \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/
