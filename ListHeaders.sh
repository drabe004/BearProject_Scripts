#!/bin/bash -l        
#SBATCH --time=96:00:00
#SBATCH --ntasks=20
#SBATCH --mem=400g
#SBATCH --tmp=200g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu


cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS
module load python


python3 List_headers.py 

