#!/bin/bash

# Load environment variables
set -a
[ -f ../.env ] && source ../.env
set +a

# Function to create a directory and set permissions
create_dir() {
    DIR_PATH="$1"
    if [ ! -d "$DIR_PATH" ]; then
        echo "📁 Creating directory: $DIR_PATH"
        mkdir -p "$DIR_PATH"
        chmod 777 "$DIR_PATH"
        echo "✅ $DIR_PATH created successfully."
    else
        echo "⚡ Directory already exists: $DIR_PATH"
    fi
}

# Create required directories
create_dir "$ROOT_VOLUME"
create_dir "$LOGS_PATH"
create_dir "$MYSQL_MOUNT_LOCATION"
create_dir "$POSTGRES_MOUNT_LOCATION"
create_dir "$SPARK_MOUNT_LOCATION"
create_dir "$SPARK_LOGS_MOUNT_LOCATION"
create_dir "$DELTA_LAKE_STORAGE_LOCATION"
create_dir "$NEO4J_MOUNT_LOCATION"
create_dir "$NEO4J_LOGS_MOUNT_LOCATION"
create_dir "$NEO4J_PLUGINS_MOUNT_LOCATION"
create_dir "$NEO4J_IMPORTS_MOUNT_LOCATION"


echo "🚀 All required directories are now set up!"