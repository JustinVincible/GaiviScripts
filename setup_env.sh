#!/bin/bash

# Check if a repository name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <repo-name>"
    exit 1
fi

# Variables
REPO_NAME=$1
PYTHON_VERSION=${2:-3.10}  # Default to Python 3.10 if not specified
BASE_DIR="<user-remote-dir>"
TARGET_DIR="$BASE_DIR/$REPO_NAME"
ENV_NAME="${REPO_NAME}_env"  # Conda environment name

# Ensure the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist. Please ensure the repository is present."
    exit 1
fi

# Load Conda (ensure this path is correct for your system)
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

# Remove existing Conda environment if it exists
if conda env list | grep -q "$ENV_NAME"; then
    echo "Removing existing Conda environment: $ENV_NAME"
    conda remove --name "$ENV_NAME" --all -y
fi

# Create a new Conda environment
echo "Creating new Conda environment: $ENV_NAME with Python $PYTHON_VERSION"
conda create --name "$ENV_NAME" python="$PYTHON_VERSION" -y  # Change version as needed

# Activate the Conda environment
echo "Activating Conda environment: $ENV_NAME"
conda activate "$ENV_NAME"

# Install manual packages line by line
MANUAL_FILE="$TARGET_DIR/manual_packages.txt"
if [ -f "$MANUAL_FILE" ]; then
    echo "Executing pip install commands from manual_packages.txt..."
    while IFS= read -r cmd || [ -n "$cmd" ]; do
        if [[ ! -z "$cmd" && ! "$cmd" =~ ^# ]]; then  # Skip empty lines and comments
            echo "Running: $cmd"
            eval "$cmd" || echo "⚠️  Failed to run: $cmd"
        fi
    done < "$MANUAL_FILE"
else
    echo "Warning: No manual_packages.txt found in $TARGET_DIR. Skipping."
fi

# Install dependencies from requirements.txt
REQ_FILE="$TARGET_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "Installing dependencies from requirements.txt..."
    python -m pip install --upgrade pip
    pip cache purge  # Clear any corrupted package cache
    pip install --no-cache-dir -r "$REQ_FILE"
else
    echo "Warning: No requirements.txt found in $TARGET_DIR. Skipping."
fi



# Change to the target directory
cd "$TARGET_DIR" || exit

echo "Setup complete. You are now in $TARGET_DIR with Conda environment: $ENV_NAME."