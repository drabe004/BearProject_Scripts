#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --tmp=50g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


path/to/your/dir

module load python

python 14_Extract_Unrounded_pvalues.py <directory_path> <prefixes_file> <output_file>


