FROM gradle:jdk21 AS gradle
RUN set -x \
    && echo "plugins{id'application'};repositories{mavenCentral()};task getDeps(type:Copy){from sourceSets.main.runtimeClasspath; into 'lib/'};dependencies {" > build.gradle \
    && echo "implementation 'com.fasterxml.jackson.core:jackson-databind:2.18.2'" >> build.gradle \
    && echo "implementation 'com.google.guava:guava:33.3.1-jre'" >> build.gradle \
    && echo "implementation 'com.google.code.gson:gson:2.11.0'" >> build.gradle \
    && echo "}" >> build.gradle \
    && gradle getDeps

FROM eclipse-temurin:21
COPY --from=gradle /home/gradle/lib /demo/lib

RUN useradd -m -d /home/user01 user01 \
    && mkdir -p /demo/src /demo/bin \
    && chown -R user01:user01 /demo \
    && apt-get update && apt-get install -y --no-install-recommends \
    asciinema \
    fonts-nanum-coding \
    time \
    unzip \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /demo
