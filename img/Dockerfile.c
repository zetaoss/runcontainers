FROM debian:12.8-slim

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    time \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/
