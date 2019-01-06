#!/usr/bin/env bash
set -e

unset SPARK_MASTER_PORT
unset ZEPPELIN_PORT
unset ZEPPELIN_SSL_PORT

if [ "$#" != "2" ]; then
  echo "ERROR: Missing required arguments"
  echo "Expecting ./docker-zeppelin --master-hostname=<fully qualified hostname> --master-port=<master service port>"
  echo "Got: $@"
fi

for i in "$@"
do
case $i in
    -p=*|--master-port=*)
    SERVICE_PORT="${i#*=}"
    echo "MasterPort is $SERVICE_PORT"
    ;;
    -m=*|--master-hostname=*)
    MASTER_HOSTNAME="${i#*=}"
    echo "MasterHostname is $MASTER_HOSTNAME"
    ;;
    *)
            # unknown option
    ;;
esac
done

echo "Updating $MASTER_HOSTNAME"
export MASTER="spark://$MASTER_HOSTNAME:$SERVICE_PORT"

echo "=== Launching Zeppelin ==="
${ZEPPELIN_HOME}/bin/zeppelin.sh "${ZEPPELIN_CONF_DIR}"
