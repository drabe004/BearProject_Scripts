#!/bin/bash -l        
#SBATCH --time=96:00:00
#SBATCH --ntasks=20
#SBATCH --mem=400g
#SBATCH --tmp=200g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


cd path/to/your/dir

module load python


python3 List_headers.py 

