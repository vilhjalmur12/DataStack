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

echo "🚀 All required directories are now set up!"



