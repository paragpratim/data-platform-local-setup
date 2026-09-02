#!/usr/bin/env bash
set -e

# ===========================================================================
# Dynamically append the resolved Docker environment variables to Spark Confs
# ===========================================================================
echo "" >> "${SPARK_HOME}/conf/spark-defaults.conf"
echo "# Dynamic Polaris Runtime Configurations" >> "${SPARK_HOME}/conf/spark-defaults.conf"
echo "spark.sql.catalog.polaris.warehouse    ${POLARIS_BOOTSTRAP_CATALOG_NAME}" >> "${SPARK_HOME}/conf/spark-defaults.conf"
echo "spark.sql.catalog.polaris.credential   ${POLARIS_ROOT_CLIENT_ID}:${POLARIS_ROOT_CLIENT_SECRET}" >> "${SPARK_HOME}/conf/spark-defaults.conf"

# SPARK_MODE selects the role this container plays: master | worker | notebook
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
  notebook)
    exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token= --ServerApp.password=
    ;;
  *)
    echo "Unknown SPARK_MODE: ${SPARK_MODE}" >&2
    exit 1
    ;;
esac
