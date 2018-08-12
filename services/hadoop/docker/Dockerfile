ARG DOCKER_USER
ARG BASE_DOCKER_VERSION=1
FROM $DOCKER_USER/base:${BASE_DOCKER_VERSION}

ARG MIRROR="http://archive.apache.org/dist"
ARG HADOOP_VERSION="hadoop-2.7.6"
ARG HADOOP_BIN="${MIRROR}/hadoop/common/${HADOOP_VERSION}/${HADOOP_VERSION}.tar.gz"

ENV HADOOP_HOME /hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

USER root

RUN set -x && \
    mkdir $HADOOP_HOME && \
    wget --quiet $HADOOP_BIN && \
    tar xzf $HADOOP_VERSION.tar.gz && \
    rm -rf $HADOOP_VERSION.tar.gz && \
    mv $HADOOP_VERSION/* $HADOOP_HOME/ && \
    rm -rf ${HADOOP_HOME}/share/doc && \
    rm -rf $HADOOP_VERSION && \
    chown -R ${CONTAINER_USER}:${CONTAINER_USER} $HADOOP_HOME

USER $CONTAINER_USER
