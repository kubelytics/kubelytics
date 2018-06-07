ARG DOCKER_USER
ARG SPARK_VERSION
FROM ${DOCKER_USER}/spark:${SPARK_VERSION}

ARG MIRROR="http://www-us.apache.org/dist"
ARG ZEPPELIN_VERSION="0.7.3"
ARG ZEPPELIN_BIN="${MIRROR}/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-$ZEPPELIN_VERSION-bin-all.tgz"
ENV PYTHONPATH "$SPARK_HOME/python"

USER root

ENV ZEPPELIN_HOME "/zeppelin"

RUN mkdir $ZEPPELIN_HOME && \
    wget --quiet $ZEPPELIN_BIN && \
    tar xzf zeppelin-$ZEPPELIN_VERSION-bin-all.tgz && \
    rm -rf zeppelin-$ZEPPELIN_VERSION-bin-all.tgz && \
    mv zeppelin-$ZEPPELIN_VERSION-bin-all/* $ZEPPELIN_HOME && \
    rm -rf zeppelin-$ZEPPELIN_VERSION-bin-all && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} $ZEPPELIN_HOME

WORKDIR $ZEPPELIN_HOME

ADD docker-zeppelin.sh /
RUN chmod +x /docker-* && chown -R ${CONTAINER_USER}:${CONTAINER_USER} /docker-*

USER $CONTAINER_USER
