#!/usr/bin/env bash
set -e

# SPARK_MODE selects the role this container plays: master | worker
case "${SPARK_MODE:-master}" in
  master)
    exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.master.Master \
        --host "$(hostname)" --port 7077 --webui-port 8080
    ;;
  worker)
    if [ -z "${SPARK_MASTER_URL}" ]; then
      echo "SPARK_MASTER_URL must be set for SPARK_MODE=worker" >&2
      exit 1
    fi
    exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.worker.Worker \
        "${SPARK_MASTER_URL}" --webui-port 8081
    ;;
  *)
    echo "Unknown SPARK_MODE: ${SPARK_MODE}" >&2
    exit 1
    ;;
esac
