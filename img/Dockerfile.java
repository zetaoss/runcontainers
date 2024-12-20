FROM gradle:jdk21 AS gradle
RUN set -eux \
    && useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    asciinema \
    fonts-nanum-coding \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /demo/src /demo/bin \
    && cd /demo \
    && echo "plugins{id'application'};repositories{mavenCentral()};task getDeps(type:Copy){from sourceSets.main.runtimeClasspath; into 'lib/'};dependencies {" > build.gradle \
    && echo "implementation 'com.fasterxml.jackson.core:jackson-databind:2.18.2'" >> build.gradle \
    && echo "implementation 'com.google.guava:guava:33.3.1-jre'" >> build.gradle \
    && echo "implementation 'com.google.code.gson:gson:2.11.0'" >> build.gradle \
    && echo "}" >> build.gradle \
    && gradle getDeps \
    && chown -R user01:user01 /demo

USER user01
WORKDIR /demo
