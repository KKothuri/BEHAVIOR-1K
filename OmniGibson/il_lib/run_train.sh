#!/bin/bash

#SBATCH --job-name=behavior_train
#SBATCH --partition=kira-lab,overcap
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --gpus=a40:1
#SBATCH --output=/nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs/behavior_train_%j.out
#SBATCH --error=/nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs/behavior_train_%j.err
#SBATCH --qos=short

mkdir -p /nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs
cd /nethome/skothuri7/flash/repos/BEHAVIOR-1K/OmniGibson/il_lib

source ~/flash/miniconda/etc/profile.d/conda.sh
conda activate behavior

# --- W&B Setup ---
# Set your W&B API key here to avoid the interactive login prompt.
# You can find your key at: https://wandb.ai/authorize
export WANDB_API_KEY="be8c4ca340f29afb77d04b69020d4e3aa682c549"

# --- Run the Training Script ---
echo "Starting Behavior training script..."

python train.py \
    data_dir="/nethome/skothuri7/flash/repos/BEHAVIOR-1K/test_ds" \
    robot=r1pro \
    task=behavior \
    task.name=turning_on_radio \
    arch=diffusion_rgbd_unet

echo "Script finished."