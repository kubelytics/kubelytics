ARG DOCKER_USER
ARG HADOOP_VERSION
ARG HIVE_VERSION

FROM bde2020/hive:${HIVE_VERSION} as hive-base
FROM $DOCKER_USER/hadoop:${HADOOP_VERSION}

ARG HIVE_DB_TYPE=postgres
ARG PSQL_JDBC_VERSION=42.2.5
ARG MYSQL_JDBC_VERSION=2.3.0

ENV HIVE_HOME /hive
ENV HIVE_CONF_DIR ${HIVE_HOME}/etc
ENV PATH ${HIVE_HOME}/bin:$PATH

# Set hive metastore database type
ENV HIVE_DB_TYPE=${HIVE_DB_TYPE}

USER ${CONTAINER_USER}

COPY --chown=1000:1000 --from=hive-base /opt/hive $HIVE_HOME
COPY --chown=1000:1000 --from=hive-base /usr/local/bin/startup.sh /usr/local/bin/startup.sh
COPY --chown=1000:1000 --from=hive-base /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN set -ex && \
    sed -i "s/= \"/=\"/g" ${HIVE_HOME}/bin/ext/metastore.sh && \
    cd ${HIVE_HOME}/lib/ && \
    wget --quiet "https://jdbc.postgresql.org/download/postgresql-${PSQL_JDBC_VERSION}.jar" && \
    wget --quiet "https://downloads.mariadb.com/Connectors/java/connector-java-${MYSQL_JDBC_VERSION}/mariadb-java-client-${MYSQL_JDBC_VERSION}.jar" && \
    cd ${HIVE_HOME}

ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "startup.sh" ]
