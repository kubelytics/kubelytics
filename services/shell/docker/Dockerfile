ARG DOCKER_USER
ARG PRESTO_VERSION
ARG SPARK_VERSION
FROM $DOCKER_USER/presto:${PRESTO_VERSION} as presto

FROM $DOCKER_USER/spark:${SPARK_VERSION} as spark
ARG TTYD_VERSION

USER root

COPY --from=presto /presto/bin/presto /usr/local/bin/presto

RUN wget https://github.com/tsl0922/ttyd/releases/download/$TTYD_VERSION/ttyd-static-amd64 \
    && mv ttyd-static-amd64 /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

EXPOSE 7681

USER ${CONTAINER_USER}

CMD [ "ttyd", "bash" ]