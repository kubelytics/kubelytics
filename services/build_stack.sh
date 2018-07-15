#!/usr/bin/env bash

set -e

DOCKER_USER="kubelytics"

BASE_DOCKER_VERSION=${BASE_DOCKER_VERSION:-"1"}

HADOOP_VERSION=${HADOOP_VERSION:-"2.7.6"}
HADOOP_FULL_VERSION="hadoop-${HADOOP_VERSION}"

SPARK_VERSION=${SPARK_VERSION:-"2.1.2"}
SPARK_FULL_VERSION="spark-${SPARK_VERSION}"

ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-"0.7.3"}

PRESTO_VERSION=${PRESTO_VERSION:-"0.189"}

TTYD_VERSION=${TTYD_VERSION:-"1.4.0"}

RELEASE="1"
LOGIN="1"

for i in "$@"
do
case $i in
    --no-release)
    RELEASE="0"
    ;;
    --no-login)
    LOGIN="0"
    ;;
    *)
            # unknown option
    ;;
esac
done

TEMP_DIR=$(mktemp -d -t docker_stack_build)

echo "  
Starting Docker Release

        Docker Hub User: ${DOCKER_USER}

        Base Tag: ${BASE_DOCKER_VERSION}
        Hadoop Version: ${HADOOP_VERSION}
        Spark Version: ${SPARK_VERSION}
        Zeppelin Version: ${ZEPPELIN_VERSION}
        Presto Version: ${PRESTO_VERSION}

        Logs folder at ${TEMP_DIR}"

echo "
- Building Base ${DOCKER_USER}/base:${BASE_DOCKER_VERSION}"
pushd base >> ${TEMP_DIR}/docker.base.${BASE_DOCKER_VERSION} 2>&1
docker build \
        --tag ${DOCKER_USER}/base:${BASE_DOCKER_VERSION} . >> ${TEMP_DIR}/docker.base.${BASE_DOCKER_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.base.${BASE_DOCKER_VERSION} 2>&1

echo "
- Building Hadoop ${DOCKER_USER}/hadoop:${HADOOP_VERSION}"
pushd hadoop/docker >> ${TEMP_DIR}/docker.hadoop.${HADOOP_VERSION} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg BASE_DOCKER_VERSION=${BASE_DOCKER_VERSION} \
        --build-arg HADOOP_VERSION=${HADOOP_FULL_VERSION} \
        --tag ${DOCKER_USER}/hadoop:${HADOOP_VERSION} . >> ${TEMP_DIR}/docker.hadoop.${HADOOP_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.hadoop.${HADOOP_VERSION} 2>&1

echo "
- Building Spark ${DOCKER_USER}/spark:${SPARK_VERSION}"
pushd spark/docker >> ${TEMP_DIR}/docker.spark.${SPARK_VERSION} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg SPARK_VERSION=${SPARK_FULL_VERSION} \
        --tag ${DOCKER_USER}/spark:${SPARK_VERSION} . >> ${TEMP_DIR}/docker.spark.${SPARK_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.spark.${SPARK_VERSION} 2>&1

echo "
- Building Zeppelin ${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION}"
pushd zeppelin/docker >> ${TEMP_DIR}/docker.zeppelin.${ZEPPELIN_VERSION} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg SPARK_VERSION=${SPARK_VERSION} \
        --build-arg ZEPPELIN_VERSION=${ZEPPELIN_VERSION} \
        --tag ${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION} . >> ${TEMP_DIR}/docker.zeppelin.${ZEPPELIN_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.zeppelin.${ZEPPELIN_VERSION} 2>&1

echo "
- Building Presto ${DOCKER_USER}/presto:${PRESTO_VERSION}"
pushd presto/docker >> ${TEMP_DIR}/docker.presto.${PRESTO_VERSION} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg PRESTO_VERSION=${PRESTO_VERSION} \
        --tag ${DOCKER_USER}/presto:${PRESTO_VERSION} . >> ${TEMP_DIR}/docker.presto.${PRESTO_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.presto.${PRESTO_VERSION} 2>&1

echo "
- Building Shell Container ${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION}"
pushd shell/docker >> ${TEMP_DIR}/docker.shell.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg SPARK_VERSION=${SPARK_VERSION} \
        --build-arg PRESTO_VERSION=${PRESTO_VERSION} \
        --build-arg TTYD_VERSION=${TTYD_VERSION} \
        --tag ${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} . >> ${TEMP_DIR}/docker.shell.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1

popd >> ${TEMP_DIR}/docker.shell.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1

if [ "${RELEASE}" == "1" ]; then
        echo "
        - Pushing images to Docker Hub"
        if [ "${LOGIN}" == "1" ]; then
                docker login --username $DOCKER_USER --password $DOCKER_PASSWORD >> ${TEMP_DIR}/docker.push.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1
        fi
        for image in "${DOCKER_USER}/base:${BASE_DOCKER_VERSION}" \
                        "${DOCKER_USER}/hadoop:${HADOOP_VERSION}" \
                        "${DOCKER_USER}/spark:${SPARK_VERSION}" \
                        "${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION}" \
                        "${DOCKER_USER}/presto:${PRESTO_VERSION}" \
                        "${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION}" ; do
        echo "
        - Pushing $image"
        docker push $image >> ${TEMP_DIR}/docker.push.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1
        done
        if [ "${LOGIN}" == "1" ]; then
                docker logout >> ${TEMP_DIR}/docker.push.${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} 2>&1
        fi
fi

echo "

    Release Completed!

"
