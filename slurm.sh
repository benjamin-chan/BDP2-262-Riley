#!/usr/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=exacloud
#SBATCH --time=360
srun /usr/bin/Rscript scripts/script.R
