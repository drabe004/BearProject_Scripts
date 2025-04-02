#!/bin/bash -l        
#SBATCH --time=20:00:00
#SBATCH --ntasks=2
#SBATCH --mem=50g
#SBATCH --tmp=25g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


cd path/to/your/files

module load python3/3.7.1_anaconda

module load conda

# Source the Conda initialization script
source /common/software/install/migrated/anaconda/python3-2020.07-mamba/etc/profile.d/conda.sh

# Activate the new Conda environment
conda activate newbioenv

# If needed, adjust PYTHONPATH for the new environment
# Note: Adjusting PYTHONPATH is often not necessary when using Conda environments,
# as dependencies should be managed within the environment itself.
# export PYTHONPATH="${PYTHONPATH}:/path/to/new/environment/python/packages"

python 8_writeTrees.py ALL_specieS_NBL.tre Hand_Edited_Alignments
