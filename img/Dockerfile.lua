ARG DEBIAN_TAG=latest
FROM debian:${DEBIAN_TAG}

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    curl \
    lua5.4 \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/
