#!/bin/bash -l        
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --mem=20g
#SBATCH --tmp=10g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail



module load python3


cd /your/dir

python3 7.5_CLEANUP_ALNS_LOOP.py #inputdir PAL2NAL_alns  #outputdir PAL2NAL_alns_DCLEAN #percentagenotgaps .75 debug_log.txt




