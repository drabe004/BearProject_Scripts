#!/bin/bash -l        
#SBATCH --time=96:00:00
#SBATCH --ntasks=20
#SBATCH --mem=400g
#SBATCH --tmp=200g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


###This script scans a directory of .fasta files, extracts all unique sequence headers, removes duplicates, and saves the sorted list of headers to a text file.



cd path/to/your/dir

module load python

python3 List_headers.py /path/to/PAL2NAL_alns -o my_headers.txt

