#!/usr/bin/bash
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=exacloud
#SBATCH --time=720
srun /usr/bin/Rscript scripts/script.R
