#!/bin/bash

# Load environment variables
set -a
[ -f ../.env ] && source ../.env
set +a

mkdir -p "$JAR_PATH"

echo "📥 Downloading Delta Lake JARs..."
curl -L -o "$JAR_PATH/delta-core_2.12-${DELTA_VERSION}.jar" \
  "https://repo1.maven.org/maven2/io/delta/delta-core_2.12/${DELTA_VERSION}/delta-core_2.12-${DELTA_VERSION}.jar"

curl -L -o "$JAR_PATH/delta-storage-${DELTA_VERSION}.jar" \
  "https://repo1.maven.org/maven2/io/delta/delta-storage/${DELTA_VERSION}/delta-storage-${DELTA_VERSION}.jar"

echo "✅ Delta Lake JARs downloaded to $JAR_PATH"
