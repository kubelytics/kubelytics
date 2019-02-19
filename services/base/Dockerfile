FROM python:3.6.8-slim

RUN apt-get update && \
    apt-get install -y --allow-unauthenticated curl wget less && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Installing Java JRE 8
RUN apt-get update && apt-get install -y --no-install-recommends \
        bzip2 \
        unzip \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

RUN set -x \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless \
        ca-certificates-java \
    && rm -rf /var/lib/apt/lists/* \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

ARG CONTAINER_USER="kubelytics"
ENV CONTAINER_USER ${CONTAINER_USER}
ENV KUBELYTICS_HOME /opt/kubelytics

RUN useradd \
        --uid 1000 \
        --create-home \
        --home-dir ${KUBELYTICS_HOME} \
        --shell /bin/bash \
        $CONTAINER_USER

USER $CONTAINER_USER
