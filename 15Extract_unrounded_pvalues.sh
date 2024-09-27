#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --tmp=50g
#SBATCH -p pachon
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu


/panfs/jay/groups/26/mcgaughs/drabe004/Fish_MSAs_Fernando/

module load python


#python extract_pvalues.py <directory_path> <prefixes_file> <output_file>

python Extract_Unrounded_pvalues.py 1_FGBG_split BUSTED_0pval_genes.txt 1_FGBG_split/BUSTED_FGBG_OUT/BUSTED_unrounded_pvalues.csv

