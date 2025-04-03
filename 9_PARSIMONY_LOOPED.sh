#!/bin/bash -l        
#SBATCH --time=2:00:00
#SBATCH --ntasks=2
#SBATCH --mem=50g
#SBATCH --tmp=25g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


cd path/to/your/dir
module load R

export PATH=/common/software/install/spack/linux-centos7-ivybridge/gcc-8.2.0/r-4.2.2-vp7tydeosl55o3d5hp5plulp6evljtbp/bin:$PATH

###This script uses asr_max_parsimony(),(castor R package) to take a list of foreground species for each tree, and reconstruct the ancestral states to nodes, designating nodes and tips as part of the foreground with the notation needed for input into HyPhy
####You can adjust the reconstruction method to your preference in the r script


Rscript 9_PARSIMONY_LOOPED.r --input /path/to/alignments --foreground /path/to/foreground_taxa.txt

