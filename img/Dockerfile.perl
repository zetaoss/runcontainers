FROM perl:5.40-slim

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    time \
    && rm -rf /var/lib/apt/lists/* \
    && cpan -i Math::NumberCruncher

USER user01
WORKDIR /home/user01/
