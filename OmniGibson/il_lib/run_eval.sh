#!/bin/bash

#SBATCH --job-name=behavior_eval
#SBATCH --array=0-4%5
#SBATCH --partition=kira-lab,overcap
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --gpus=a40:1
#SBATCH --nodelist=dave,crushinator,sonny,protocol
#SBATCH --output=/nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs/behavior_eval_%A/slurm_%a.out
#SBATCH --error=/nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs/behavior_eval_%A/slurm_%a.err
#SBATCH --qos=short

source ~/flash/miniconda/etc/profile.d/conda.sh
conda activate behavior

# --- Run the Evaluation Script ---
echo "Starting Behavior evaluation script..."

EVAL_ARGS=""
if [[ "$1" == "--train" ]]; then
    echo "Running evaluation on TRAINING instances."
    EVAL_ARGS="eval_on_train_instances=True"
else
    echo "Running evaluation on TEST instances."
fi

LOG_DIR="/nethome/skothuri7/flash/repos/BEHAVIOR-1K/logs/behavior_eval_${SLURM_JOB_ID}"
mkdir -p $LOG_DIR

# Each of the 5 parallel jobs will run 2 instances.
# SLURM_ARRAY_TASK_ID will be 0, 1, 2, 3, 4.
# This will cover instance IDs 0-9.
START_IDX=$((SLURM_ARRAY_TASK_ID * 2))
END_IDX=$((START_IDX + 1))

python -m omnigibson.learning.eval \
    policy=local \
    task.name=turning_on_radio \
    log_path="${LOG_DIR}" \
    eval_instance_ids="[${START_IDX},${END_IDX}]" \
    ${EVAL_ARGS}

echo "Script finished."