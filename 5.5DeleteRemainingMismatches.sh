#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu

cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS

module load python3

python3 5.5DeleteRemainingMISMATCHES.py  /panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Renamed_output_ALL/  /panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Renamed_output_ALL/matching
