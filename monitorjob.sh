#!/bin/bash

# Check if job ID is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <JOB_ID>"
    exit 1
fi

JOB_ID="$1"
echo "Monitoring SLURM job: $JOB_ID"
echo "Press Ctrl+C to stop monitoring."

while true; do
    clear
    echo "===== SLURM Job Status ====="
    squeue -j "$JOB_ID" -o "%.10i %.9P %.25j %.8u %.8T %.10M %.6D %.20R"

    echo -e "\n===== Node Usage ====="
    scontrol show job "$JOB_ID" | grep -E 'NodeList|NumNodes|State|RunTime'

    NODE=$(squeue -j "$JOB_ID" -o "%.20R" | tail -n 1)

    if [ -n "$NODE" ]; then
        echo -e "\n===== GPU Usage on $NODE ====="
        ssh "$NODE" "nvidia-smi"

        echo -e "\n===== CPU & Memory Usage on $NODE ====="
        ssh "$NODE" "top -b -n 1 | head -20"
    fi

    sleep 10
done