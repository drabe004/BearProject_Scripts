#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=2
#SBATCH --mem=100g
#SBATCH --tmp=50g


cd /your/dir

modue load python

python3 script.py dir/to/input/files dir/to/output/files
