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

#conda create -n newbioenv python=3.7 biopython
#this is the venv for this script

# Source the Conda initialization script
#source /common/software/install/migrated/anaconda/python3-2020.07-mamba/etc/profile.d/conda.sh
#This is a fix for a cluster module update issue 
# export PYTHONPATH="${PYTHONPATH}:/path/to/new/environment/python/packages"


# Activate the new Conda environment
conda activate newbioenv


###INPUT
#ALL_specieS_NBL.tre  a master species topology with no branch lengths 
#Pal2nal_alns a directory of codon alignments from PAL2nal. 
## suggest running clean up script after pal2nal for second pass

python 8_writeTrees.py ALL_specieS_NBL.tre Pal2nal_alns
