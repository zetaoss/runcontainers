# main
FROM debian:13.7-slim

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/
