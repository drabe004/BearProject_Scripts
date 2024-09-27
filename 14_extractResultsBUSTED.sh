#!/bin/bash -l        
#SBATCH --time=2:00:00
#SBATCH --ntasks=2
#SBATCH --mem=50g
#SBATCH --tmp=25g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu


cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS

module load python


python3 14Extract_resultsBUSTED.py



