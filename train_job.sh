#!/bin/bash
#SBATCH --time=1-0                 # Max job runtime~:
#SBATCH -p general                  # Partition name
#SBATCH --nodes=1                   # Number of nodes
#SBATCH -w "GPU2"                  # Specific node
#SBATCH --job-name=<name>            # Job name
#SBATCH --ntasks-per-node=1         # Number of tasks per node
#SBATCH --gpus-per-node=1           # GPUs per node
#SBATCH --output=train_job.out           # Output log file
#SBATCH --mail-type=BEGIN,END,FAIL  # Email notifications
#SBATCH --mail-user=<name>@usf.edu # Email address for SLURM notifications

# Set up distributed training variables
export MASTER_PORT=$((10000 + SLURM_JOB_ID % 10000))
export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)

echo "Node ID: $SLURM_NODEID | Master Node: $MASTER_ADDR"
echo "Launching Python script..."

# Activate conda environment
source ~/.bashrc
conda activate <env_name> || { echo "Failed to activate Conda environment"; exit 1; }

# Print environment variables for debugging
printenv | sort > train_job.out

# Run Python script with logging
python -u  train_apple.py > train_job.out
