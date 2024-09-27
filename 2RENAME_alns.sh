#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=2
#SBATCH --mem=100g
#SBATCH --tmp=50g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu

cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS

modue load python

python3 RENAME_alns.py HillerGenes ###pathway to input files