#!/bin/bash
#SBATCH -p gentzkow,normal
#SBATCH --job-name=template_test
#SBATCH --array=1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=12GB
#SBATCH --time=48:00:00
#SBATCH --mail-user=jccp@stanford.edu
#SBATCH --mail-type=ALL

USER=$(whoami)
IMAGE_SIF="/home/groups/gentzkow/${USER}/simg/template_latest.sif"
STATALIC="/share/software/user/restricted/stata/17/licenses/econ.lic"
GITHUB_KEY="/home/users/${USER}/.ssh" # Default SSH file name if following Github tutorial
DROPBOX="/oak/stanford/groups/gentzkow/${USER}/Dropbox" # Change to Dropbox folder name

singularity exec --bind "${STATALIC}":/usr/local/stata/stata.lic,"${DROPBOX}":/home/statauser/dropbox,"${GITHUB_KEY}":/home/statauser/.ssh,"$(pwd)":/home/statauser/template /home/groups/gentzkow/jccp/simg/template_latest.sif bash -c "source /home/statauser/miniconda3/bin/activate template && /home/statauser/miniconda3/envs/template/bin/python run_all.py" 