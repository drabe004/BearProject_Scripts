#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --tmp=50g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


####This script recursively searches a given directory for JSON files ending with BUSTED.json, extracts p-values from the "test results" section, and writes the extracted gene prefixes and p-values to a CSV file. Note that this is the only place you can find unrounded p-values for proper multiple test correction


path/to/your/dir

module load python

python 14_Extract_Unrounded_pvalues.py <directory_path> <prefixes_file> <output_file>


