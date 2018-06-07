ARG DOCKER_USER
ARG HADOOP_VERSION
FROM $DOCKER_USER/hadoop:${HADOOP_VERSION}

ARG MIRROR="https://repo1.maven.org/maven2"
ARG PRESTO_VERSION="0.195"
ARG PRESTO_BIN="${MIRROR}/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz"
ARG PRESTO_CLI_BIN="${MIRROR}/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar"

ENV PRESTO_HOME /presto
ENV PRESTO_CONF_DIR ${PRESTO_HOME}/etc
ENV PATH $PATH:$PRESTO_HOME/bin

USER root

RUN mkdir $PRESTO_HOME && \
    wget --quiet $PRESTO_BIN && \
    tar xzf presto-server-${PRESTO_VERSION}.tar.gz && \
    rm -rf presto-server-${PRESTO_VERSION}.tar.gz && \
    mv presto-server-${PRESTO_VERSION}/* $PRESTO_HOME && \
    rm -rf presto-server-${PRESTO_VERSION} && \
    mkdir -p ${PRESTO_CONF_DIR}/catalog/ && \
    mkdir -p ${PRESTO_HOME}/data && \
    cd ${PRESTO_HOME}/bin && \
    wget --quiet ${PRESTO_CLI_BIN} && \
    mv presto-cli-${PRESTO_VERSION}-executable.jar presto && \
    chmod +x presto && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} $PRESTO_HOME

# Need to switch to python2
# See: https://github.com/prestodb/presto/issues/4678
ENV PYTHON2_DEBIAN_VERSION 2.7.9-1
RUN apt-get update && apt-get install -y --no-install-recommends \
        python="${PYTHON2_DEBIAN_VERSION}" \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/local/bin \
    && rm -rf idle pydoc python python-config

ADD docker-presto.sh /
RUN chmod +x /docker-* && chown -R ${CONTAINER_USER}:${CONTAINER_USER} /docker-*

USER $CONTAINER_USER
