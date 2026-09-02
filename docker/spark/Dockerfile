ARG SPARK_VERSION=3.5.1
ARG HADOOP_VERSION=3
ARG ICEBERG_VERSION=1.5.2
ARG HADOOP_AWS_VERSION=3.3.4
ARG AWS_SDK_BUNDLE_VERSION=1.12.262

# ---------------------------------------------------------------------------
# Stage: spark-base -> Spark + Hadoop + Iceberg + S3 (MinIO) support jars
# ---------------------------------------------------------------------------
FROM eclipse-temurin:11-jre-jammy AS spark-base

ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG ICEBERG_VERSION
ARG HADOOP_AWS_VERSION
ARG AWS_SDK_BUNDLE_VERSION

ENV SPARK_HOME=/opt/spark \
    PATH=/opt/spark/bin:/opt/spark/sbin:$PATH \
    PYSPARK_PYTHON=python3

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl python3 python3-pip procps \
    && rm -rf /var/lib/apt/lists/*

# Install Spark via the pyspark wheel (PyPI/CDN) instead of the slow/throttled
# archive.apache.org tarball mirror; the wheel bundles the same bin/sbin/jars.
RUN python3 -m pip install --no-cache-dir --retries 10 "pyspark==${SPARK_VERSION}" \
    && ln -s "$(python3 -c 'import pyspark, os; print(os.path.dirname(pyspark.__file__))')" "${SPARK_HOME}"

# Iceberg runtime + AWS/S3 bundle so Spark can talk to the Polaris catalog and MinIO.
# These are the essential pieces for Iceberg SQL + S3A access; no extra catalog-specific
# jar is required for Polaris because it is exposed as a REST catalog endpoint.
RUN curl -fsSL --retry 5 --retry-all-errors -o "${SPARK_HOME}/jars/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VERSION}.jar" \
        "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/${ICEBERG_VERSION}/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VERSION}.jar" \
    && curl -fsSL --retry 5 --retry-all-errors -o "${SPARK_HOME}/jars/iceberg-aws-bundle-${ICEBERG_VERSION}.jar" \
        "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar" \
    && curl -fsSL --retry 5 --retry-all-errors -o "${SPARK_HOME}/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
        "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
    && curl -fsSL --retry 5 --retry-all-errors -o "${SPARK_HOME}/jars/aws-java-sdk-bundle-${AWS_SDK_BUNDLE_VERSION}.jar" \
        "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_BUNDLE_VERSION}/aws-java-sdk-bundle-${AWS_SDK_BUNDLE_VERSION}.jar"

COPY conf/spark-defaults.conf "${SPARK_HOME}/conf/spark-defaults.conf"
COPY docker/spark/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

WORKDIR /opt/spark
ENTRYPOINT ["/opt/entrypoint.sh"]

# ---------------------------------------------------------------------------
# Stage: notebook -> spark-base + JupyterLab, used by the jupyter service
# ---------------------------------------------------------------------------
FROM spark-base AS notebook

RUN pip3 install --no-cache-dir jupyterlab==4.2.5 pandas pyarrow

RUN mkdir -p /home/iceberg/notebooks /home/iceberg/warehouse
WORKDIR /home/iceberg/notebooks

EXPOSE 8888
ENTRYPOINT ["/opt/entrypoint.sh"]
