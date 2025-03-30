#!/bin/bash


# Define local and remote paths
LOCAL_DIR="/PycharmProjects/Datasets/"
REMOTE_USER="<your-username>"
REMOTE_HOST="<your-server>"
REMOTE_DIR="<remote-dir>"

# Ensure the local dataset directory exists
if [ ! -d "$HOME$LOCAL_DIR" ]; then
    echo "Error: Local dataset folder does not exist at $LOCAL_DIR"
    exit 1
fi

# Get list of dataset folders from local machine
LOCAL_DATASETS=($(ls -d "$HOME$LOCAL_DIR"*/ | xargs -n 1 basename))

# Get list of dataset folders from SLURM cluster
REMOTE_DATASETS=$(ssh "$REMOTE_USER@$REMOTE_HOST" "ls -d $REMOTE_DIR*/ 2>/dev/null | xargs -n 1 basename")

# Find matching and new dataset folders
MATCHING_DATASETS=()
NEW_DATASETS=()
for dataset in "${LOCAL_DATASETS[@]}"; do
    if echo "$REMOTE_DATASETS" | grep -qx "$dataset"; then
        MATCHING_DATASETS+=("$dataset")  # Exists in both
    else
        NEW_DATASETS+=("$dataset")  # Exists only locally
    fi
done

# Sync matching datasets (ensure exact copy)
for dataset in "${MATCHING_DATASETS[@]}"; do
    echo "Syncing existing dataset: $dataset"
    rsync -avz --delete "$HOME$LOCAL_DIR$dataset/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR$dataset/"
done

# Upload new datasets to SLURM
for dataset in "${NEW_DATASETS[@]}"; do
    echo "Uploading new dataset: $dataset"
    rsync -avz "$HOME$LOCAL_DIR$dataset/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR$dataset/"
done

echo "Dataset sync complete!"

