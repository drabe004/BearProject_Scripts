#!/bin/bash -l        
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --mem=20g
#SBATCH --tmp=10g
#SBATCH -p cavefish
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu



module load python3


cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS

python3 TRYAGAIN_CLEANUP_ALNS_LOOP.py PAL2NAL_alns  PAL2NAL_alns_DCLEAN .75 debug_log.txt




