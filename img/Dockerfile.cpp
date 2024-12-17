# main
ARG DEBIAN_TAG=latest
FROM debian:${DEBIAN_TAG} AS main

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /home/user01/

## test
FROM main AS test
RUN echo '#include <iostream>' > hello.cpp \
    && echo 'int main() {std::cout<<"hello"<<std::endl;}' >> hello.cpp \
    && g++ hello.cpp && ./a.out

FROM main
