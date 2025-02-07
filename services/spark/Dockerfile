FROM bitnami/spark:3.5

# Set Spark JARs directory
ENV SPARK_JARS_DIR=/opt/spark/jars

# Copy pre-downloaded JARs from the build context
COPY jars/*.jar ${SPARK_JARS_DIR}/

# Set classpath for Spark
ENV SPARK_EXTRA_CLASSPATH=${SPARK_JARS_DIR}/*
