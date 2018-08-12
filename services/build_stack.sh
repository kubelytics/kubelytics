#!/usr/bin/env bash

set -e

DOCKER_USER="kubelytics"

BASE_DOCKER_VERSION=${BASE_DOCKER_VERSION:-"2.0.0"}

HADOOP_VERSION=${HADOOP_VERSION:-"2.9.0"}
HADOOP_FULL_VERSION="hadoop-${HADOOP_VERSION}"

SPARK_VERSION=${SPARK_VERSION:-"2.3.1"}
SPARK_FULL_VERSION="spark-${SPARK_VERSION}"

ZEPPELIN_VERSION=${ZEPPELIN_VERSION:-"0.8.0"}

PRESTO_VERSION=${PRESTO_VERSION:-"0.203"}

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

TEMP_DIR=$(mktemp -d -t docker_stack_buildXXXX)
BUILD_LOG=${BUILD_LOG:-"${TEMP_DIR}/docker.build.log"}

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
pushd base >> ${BUILD_LOG} 2>&1
docker build \
        --tag ${DOCKER_USER}/base:${BASE_DOCKER_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

echo "
- Building Hadoop ${DOCKER_USER}/hadoop:${HADOOP_VERSION}"
pushd hadoop/docker >> ${BUILD_LOG} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg BASE_DOCKER_VERSION=${BASE_DOCKER_VERSION} \
        --build-arg HADOOP_VERSION=${HADOOP_FULL_VERSION} \
        --tag ${DOCKER_USER}/hadoop:${HADOOP_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

echo "
- Building Spark ${DOCKER_USER}/spark:${SPARK_VERSION}-${HADOOP_VERSION}"
pushd spark/docker >> ${BUILD_LOG} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg SPARK_VERSION=${SPARK_FULL_VERSION} \
        --tag ${DOCKER_USER}/spark:${SPARK_VERSION}-${HADOOP_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

echo "
- Building Zeppelin ${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION}-${SPARK_VERSION}"
pushd zeppelin/docker >> ${BUILD_LOG} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg SPARK_VERSION=${SPARK_VERSION} \
        --build-arg ZEPPELIN_VERSION=${ZEPPELIN_VERSION} \
        --tag ${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION}-${SPARK_VERSION}-${HADOOP_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

echo "
- Building Presto ${DOCKER_USER}/presto:${PRESTO_VERSION}-${HADOOP_VERSION}"
pushd presto/docker >> ${BUILD_LOG} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg PRESTO_VERSION=${PRESTO_VERSION} \
        --tag ${DOCKER_USER}/presto:${PRESTO_VERSION}-${HADOOP_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

echo "
- Building Shell Container ${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION}"
pushd shell/docker >> ${BUILD_LOG} 2>&1
docker build \
        --build-arg DOCKER_USER=${DOCKER_USER} \
        --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
        --build-arg SPARK_VERSION=${SPARK_VERSION} \
        --build-arg PRESTO_VERSION=${PRESTO_VERSION} \
        --build-arg TTYD_VERSION=${TTYD_VERSION} \
        --tag ${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION} . >> ${BUILD_LOG} 2>&1

popd >> ${BUILD_LOG} 2>&1

if [ "${RELEASE}" == "1" ]; then
        echo "
        - Pushing images to Docker Hub"
        if [ "${LOGIN}" == "1" ]; then
                docker login --username $DOCKER_USER --password $DOCKER_PASSWORD >> ${BUILD_LOG} 2>&1
        fi
        for image in "${DOCKER_USER}/base:${BASE_DOCKER_VERSION}" \
                        "${DOCKER_USER}/hadoop:${HADOOP_VERSION}" \
                        "${DOCKER_USER}/spark:${SPARK_VERSION}-${HADOOP_VERSION}" \
                        "${DOCKER_USER}/zeppelin:${ZEPPELIN_VERSION}-${SPARK_VERSION}-${HADOOP_VERSION}" \
                        "${DOCKER_USER}/presto:${PRESTO_VERSION}-${HADOOP_VERSION}" \
                        "${DOCKER_USER}/shell:${HADOOP_VERSION}-${SPARK_VERSION}-${PRESTO_VERSION}" ; do
        echo "
        - Pushing $image"
        docker push $image >> ${BUILD_LOG} 2>&1
        done
        if [ "${LOGIN}" == "1" ]; then
                docker logout >> ${BUILD_LOG} 2>&1
        fi
fi

echo "

    Release Completed!

"
