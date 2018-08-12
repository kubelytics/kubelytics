ARG DOCKER_USER
ARG HADOOP_VERSION
FROM $DOCKER_USER/hadoop:${HADOOP_VERSION}

ARG MIRROR="http://archive.apache.org/dist"
ARG SPARK_VERSION="spark-2.1.2"
ARG HADOOP_SPARK_VERSION="hadoop2.7"
ARG SPARK_BIN_NAME="${SPARK_VERSION}-bin-${HADOOP_SPARK_VERSION}"
ARG SPARK_BIN="${MIRROR}/spark/${SPARK_VERSION}/${SPARK_BIN_NAME}.tgz"

USER root

ENV SPARK_HOME /spark
ENV PATH $PATH:${SPARK_HOME}/bin
RUN set -x && \
    mkdir $SPARK_HOME && \
    wget --quiet ${SPARK_BIN} && \
    tar xzf ${SPARK_BIN_NAME}.tgz && \
    rm -rf ${SPARK_BIN_NAME}.tgz && \
    mv ${SPARK_BIN_NAME}/* $SPARK_HOME/ && \
    rm -rf ${SPARK_BIN_NAME} && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} $SPARK_HOME

ADD spark-master /
ADD spark-worker /

RUN chmod +x /spark-* && chown -R ${CONTAINER_USER}:${CONTAINER_USER} /spark-*

USER ${CONTAINER_USER}
