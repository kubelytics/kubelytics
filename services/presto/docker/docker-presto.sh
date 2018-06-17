#!/usr/bin/env bash
set -e

if [ "$#" != "1" ]; then
  echo "ERROR: Missing required arguments"
  echo "Expecting ${0} --config=<config path>"
  echo "Got: $@"
  exit 1
fi

for i in "$@"
do
case $i in
    -c=*|--config=*)
    CONFIG_PATH="${i#*=}"
    echo "ConfigPath is $CONFIG_PATH"
    ;;
    *)
            # unknown option
    ;;
esac
done

cp $CONFIG_PATH/*.properties $PRESTO_CONF_DIR
cp $CONFIG_PATH/*.config $PRESTO_CONF_DIR

launcher run