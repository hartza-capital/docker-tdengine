#!/bin/bash

# Based on work of TaosData on TDEngine
# https://github.com/taosdata/TDengine-Operator/blob/main/docker/server/Dockerfile

set -e
if [[ ! "$1" = *"taosd" ]]; then
    $@
    exit
fi

CLUSTER=${CLUSTER:=}
FIRST_EP_HOST=${TAOS_FIRST_EP%:*}
SERVER_PORT=${TAOS_SERVER_PORT:-6030}

echo $TAOS_FQDN $FIRST_EP_HOST $CLUSTER
# if has mnode ep set or the host is first ep or not for cluster, just start.
if [ -f "/var/lib/taos/dnode/mnodeEpSet.json" ] || \
  [ "$TAOS_FQDN" = "$FIRST_EP_HOST" ] || [ "$CLUSTER" = "" ]; then
    $@
# others will first wait the first ep ready.
else
    if [ "$CLUSTER" != "" ] && [ "$TAOS_FIRST_EP" == "" ]; then
        echo "TAOS_FIRST_EP must be setted in cluster"
        exit
    fi
    while true
    do
        es=0
        taos -h $FIRST_EP_HOST -n startup > /dev/null || es=$?
        if [ "$es" -eq 0 ]; then
            taos -h $FIRST_EP_HOST -s "create dnode \"$TAOS_FQDN:$SERVER_PORT\";"
            break
        fi
        sleep 1s
    done
    $@
fi