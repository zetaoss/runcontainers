ARG DEBIAN_TAG=latest
FROM debian:${DEBIAN_TAG}

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    time \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/
