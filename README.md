# Gaivi Scripts

This repo contains some various linux bash scripts for automation of some tasks that I do often.

# Repository Setup Script

This Bash script automates the process of cloning, updating, and setting up a Python development environment for a GitHub repository. It is particularly useful for managing projects that require isolated Conda environments.

## Features

Clones a specified GitHub repository (or updates it if it already exists).

Ensures the repository is located in a designated base directory.

Automatically sets up a Conda environment with a specified Python version.

Installs dependencies from requirements.txt.

Cleans any existing environment to ensure a fresh setup.

## Usage

Run the script with the following command:

./setup_repo.sh <repo-name> [python-version]

## Parameters:

<repo-name>: The name of the GitHub repository to clone or update.

[python-version] (optional): The Python version to use (default: 3.10).

## Example

./setup_repo.sh MyProject 3.9

This will:

Clone or update git@github.com:JustinVincible/MyProject.git into /nvme/SISLab/Justin/MyProject.

Remove any existing Conda environment named MyProject_env.

Create a new Conda environment with Python 3.9.

Install dependencies from requirements.txt.

## Prerequisites

Ensure that the following are installed and configured on your system:

Git

Conda (Anaconda or Miniconda)

Notes

The script assumes that the Conda base environment is correctly set up.

If requirements.txt is missing, the setup process will exit without creating an environment.

The script uses pip cache purge to prevent corrupted package installations.

## Troubleshooting

If the script fails to activate the Conda environment, ensure that Conda is properly initialized:

conda init bash
source ~/.bashrc

If the Git repository does not exist, ensure the repository name is correct and that you have the correct SSH access permissions.


