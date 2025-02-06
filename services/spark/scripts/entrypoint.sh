#!/bin/bash
set -e

# Load environment variables
source /opt/bitnami/spark/conf/spark-env.sh

# Start Spark Master or Worker depending on the container role
if [[ "$SPARK_MODE" == "master" ]]; then
    /opt/bitnami/spark/sbin/start-master.sh
elif [[ "$SPARK_MODE" == "worker" ]]; then
    /opt/bitnami/spark/sbin/start-worker.sh ${SPARK_MASTER_URL}
fi

# Keep container running
exec "$@"