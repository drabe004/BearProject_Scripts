#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=2
#SBATCH --mem=100g
#SBATCH --tmp=50g


cd /panfs/to/your/dir

modue load python

python3 1rename_fastas.py pathwaygenes output_renamed_refseq2 ###pathway to input files
