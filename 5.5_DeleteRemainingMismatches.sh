#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail

cd your/path/head/dir

module load python3

python3 5.5_DeleteRemainingMISMATCHES.py  path/to/input/Renamed_output_ALL/  /path/to/outputdir/matching
