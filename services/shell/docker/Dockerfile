ARG DOCKER_USER
ARG PRESTO_VERSION
ARG SPARK_VERSION
FROM $DOCKER_USER/presto:${PRESTO_VERSION} as presto

FROM $DOCKER_USER/spark:${SPARK_VERSION} as spark

USER root

COPY --from=presto /presto/bin/presto /usr/local/bin/presto

ADD run.sh /
RUN chmod +x /run.sh && chown -R ${CONTAINER_USER}:${CONTAINER_USER} /run.sh

USER ${CONTAINER_USER}

CMD [ "/run.sh" ]