ARG DOCKER_USER
ARG PRESTO_VERSION
ARG HADOOP_VERSION
ARG SPARK_VERSION
ARG HIVE_VERSION
FROM $DOCKER_USER/presto:${PRESTO_VERSION}-${HADOOP_VERSION} as presto
FROM $DOCKER_USER/hive:${HIVE_VERSION}-${HADOOP_VERSION} as hive

FROM $DOCKER_USER/spark:${SPARK_VERSION}-${HADOOP_VERSION} as spark
ARG TTYD_VERSION

USER root

COPY --from=presto /presto/bin/presto /usr/local/bin/presto
COPY --chown=1000:1000 --from=hive /hive /hive

RUN set -x && \
    wget --quiet https://github.com/tsl0922/ttyd/releases/download/$TTYD_VERSION/ttyd_linux.x86_64 \
    && mv ttyd_linux.x86_64 /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

EXPOSE 7681

USER ${CONTAINER_USER}

CMD [ "ttyd", "bash" ]
