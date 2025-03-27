#!/bin/bash

# Base GitHub URL (Modify with your username or org)
GIT_BASE_URL="git@github.com:JustinVincible/"

# Check if a repository name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <repo-name>"
    exit 1
fi

# Variables
REPO_NAME=$1
GIT_REPO_URL="${GIT_BASE_URL}${REPO_NAME}.git"
BASE_DIR="/nvme/SISLab/Justin"
TARGET_DIR="$BASE_DIR/$REPO_NAME"
ENV_NAME="${REPO_NAME}_env"  # Conda environment name

# Ensure the base directory exists
mkdir -p "$BASE_DIR"

# Clone or update the repository
if [ -d "$TARGET_DIR" ]; then
    echo "Repository already exists at $TARGET_DIR. Pulling latest changes..."
    cd "$TARGET_DIR" && git pull
else
    echo "Cloning repository into $TARGET_DIR..."
    git clone "$GIT_REPO_URL" "$TARGET_DIR"
fi

# Check if requirements.txt exists
REQ_FILE="$TARGET_DIR/requirements.txt"
if [ ! -f "$REQ_FILE" ]; then
    echo "No requirements.txt found in $TARGET_DIR. Exiting."
    exit 1
fi

# Load Conda (ensure this is the correct path for your system)
CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

# Remove existing Conda environment if it exists
if conda env list | grep -q "$ENV_NAME"; then
    echo "Removing existing Conda environment: $ENV_NAME"
    conda remove --name "$ENV_NAME" --all -y
fi

# Create a new Conda environment
echo "Creating new Conda environment: $ENV_NAME"
conda create --name "$ENV_NAME" python=3.10 -y  # Change version as needed

# Activate the Conda environment
echo "Activating Conda environment: $ENV_NAME"
conda activate "$ENV_NAME"

# Install dependencies with pip
echo "Installing dependencies from requirements.txt..."
python -m pip install --upgrade pip
pip cache purge  # Clear any corrupted package cache
pip install --no-cache-dir -r "$REQ_FILE"

# Change to the target directory
cd "$TARGET_DIR"

echo "Setup complete. You are now in $TARGET_DIR. Happy Training!"
exec bash  # Start a new bash shell in the directory
"clonerepo.sh" 66L, 1932C