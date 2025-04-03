#!/bin/bash -l        
#SBATCH --time=2:00:00
#SBATCH --ntasks=2
#SBATCH --mem=50g
#SBATCH --tmp=25g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail

cd /path/to/your/dir

module load python


python3 14Extract_resultsRELAX.py  /path/to/RELAX_results -o custom_output.csv




