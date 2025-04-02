# USF SLURM Cluster Guide

## Summary of Steps

Using the SLURM cluster at USF involves the following key steps:

1. **Login to the Cluster**: Connect via SSH to `gaivi.cse.usf.edu`.
2. **Transfer Data**: Move datasets to the cluster using `rsync` or the provided sync script.
3. **Setup Environment**: Clone a GitHub repository and set up a Conda environment manually or use the provided setup script.
4. **Submit a Job**: Create and submit a SLURM job script, or use the example script for automated submission.
5. **Retrieve Results**: Download job results using `rsync` or the supplied retrieval script.

Each step can be done manually or quickly automated using the provided scripts. Below, we describe both approaches.

---

## Connecting to the Cluster

To use the SLURM cluster at USF, you need to connect via SSH. Open a terminal and run:

```bash
ssh <your-username>@gaivi.cse.usf.edu
```

Replace `<your-username>` with your actual username.

---

## Moving Files to the Cluster

To transfer datasets to the cluster, use `rsync`:

```bash
rsync -avz /local/path/ <your-username>@gaivi.cse.usf.edu:/remote/path/
```

Alternatively, run the provided script:

```bash
bash sync_datasets.sh
```

---

## Setting Up a Development Environment

Manually, clone a GitHub repository and set up an environment:

```bash
git clone git@github.com:JustinVincible/<repo-name>.git
cd <repo-name>
conda create --name <env-name> python=3.10 -y
conda activate <env-name>
pip install -r requirements.txt
```

Or, run the provided script:

```bash
bash setup_env.sh <repo-name>
```

---

## Submitting a SLURM Job

To submit a job manually:

1. Create a job script (e.g., `submit_job.sh`).
2. Submit it with:
   ```bash
   sbatch submit_job.sh
   ```

Or, use the provided script:

```bash
bash submit_job.sh
```

---

## Retrieving Results

Manually, download results with `rsync`:

```bash
rsync -avz <your-username>@gaivi.cse.usf.edu:/remote/path/ /local/path/
```

Or, use the provided script:

```bash
bash download_results.sh <remote-folder>
```
# Script descriptions

## clone_repo.sh

This Bash script automates the process of cloning, updating, and setting up a Python development environment for a GitHub repository. It is particularly useful for managing projects that require isolated Conda environments.

### Features

Clones a specified GitHub repository (or updates it if it already exists).

Ensures the repository is located in a designated base directory.

Automatically sets up a Conda environment with a specified Python version.

Installs dependencies from requirements.txt.

Cleans any existing environment to ensure a fresh setup.

### Usage

Run the script with the following command:

``./setup_repo.sh <repo-name> [python-version] ``

### Parameters:

<repo-name>: The name of the GitHub repository to clone or update.

[python-version] (optional): The Python version to use (default: 3.10).

### Example

``./setup_repo.sh MyProject 3.9 ``

This will:

Clone or update git@github.com:<user-name>/MyProject.git into <user-base-dir>.

Remove any existing Conda environment named MyProject_env.

Create a new Conda environment with Python 3.9.

Install dependencies from requirements.txt.

### Prerequisites

Ensure that the following are installed and configured on your system:

1. Git
2. Conda (Anaconda or Miniconda)

Update $GIT_BASE_URL and $BASE_DIR inside the script.

### Notes

The script assumes that the Conda base environment is correctly set up.

If requirements.txt is missing, the setup process will exit without creating an environment.

The script uses pip cache purge to prevent corrupted package installations.


### Troubleshooting

If the script fails to activate the Conda environment, ensure that Conda is properly initialized:
```
conda init bash
source ~/.bashrc
```
If the Git repository does not exist, ensure the repository name is correct and that you have the correct SSH access permissions.



## download_gaivi.sh

This script transfers a specified remote folder to a local directory using rsync.
Make sure to edit <download-dir> and <gaivi-username> inside the script

### Usage

`./download_gaivi.sh <remote_folder> [local_folder]`

### Parameters:

<remote_folder>: Absolute path of the remote folder to transfer.

[local_folder] (optional): Local destination folder (defaults to a timestamped directory in <download-dir>).

### Example

`./download_gaivi.sh /remote/path/to/data`

This will:

Copy /remote/path/to/data to <download-dir>/data_<timestamp>.

Ensure <download-dir> local directory exists before transfer.

## setup_env.sh

This script sets up a Conda environment for an existing repository, ensuring manual package installations if required.
Be sure to edit <user-remote-dir> inside the script.
The environment name will be <repo>_env

### Usage

`./setup_env.sh <repo-name> [python-version]
`
### Parameters:

<repo-name>: Name of the repository where the Conda environment will be set up.

[python-version] (optional): Python version to use (default: 3.10).

### Features

Removes any existing Conda environment for the repository.

Creates a fresh environment and installs packages from manual_packages.txt and requirements.txt if available.

## sync_datasets.sh

This script synchronizes local datasets with a remote SLURM cluster, ensuring that matching datasets are updated and new datasets are uploaded.
Ensure that <your-username>, <your-server>, and <remote-dir> are setup correctly.

### Usage

`./sync_datasets.sh`

### Features

Identifies datasets that exist both locally and remotely and ensures they are synchronized.

Uploads new datasets that exist locally but not remotely.

### Prerequisites

Ensure SSH access to the remote server is configured.

Set correct paths for local and remote dataset directories.
