#!/bin/bash

# Default local directory
LOCAL_BASE_DIR="/home/justin/PycharmProjects/gaivi_downloads"
USER_NAME="user-name"
# Check for required arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <remote_folder> [local_folder]"
    exit 1
fi

# Remote folder (absolute path expected)
REMOTE_FOLDER="$1"

# Extract the remote folder name
REMOTE_FOLDER_NAME=$(basename "$REMOTE_FOLDER")

# Generate timestamp
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")

# Define the local folder
LOCAL_FOLDER="${2:-$LOCAL_BASE_DIR}/${REMOTE_FOLDER_NAME}_$TIMESTAMP"

# Ensure local directory exists
mkdir -p "$LOCAL_FOLDER"

# Transfer the folder using rsync
rsync -avz --progress $USER_NAME@gaivi.cse.usf.edu:"$REMOTE_FOLDER" "$LOCAL_FOLDER"

echo "Transfer complete! Folder saved to: $LOCAL_FOLDER"