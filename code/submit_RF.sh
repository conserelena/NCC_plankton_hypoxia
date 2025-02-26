#!/bin/bash
#SBATCH -J simple
#SBATCH -o output_%A_%a.txt
#SBATCH -e errors_%A_%a.txt

#SBATCH --mail-type=ALL
#SBATCH --mail-user=consere@oregonstate.edu

#SBATCH --partition=dri.q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

# gather basic information, can be useful for troubleshooting
hostname
date
echo $SLURM_JOBID

# Load the R Module
module load R/4.4.1

# Commands to run job
Rscript random_forest_abundance.R $SLURM_ARRAY_TASK_ID