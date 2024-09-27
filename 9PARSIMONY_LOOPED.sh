#!/bin/bash -l        
#SBATCH --time=2:00:00
#SBATCH --ntasks=2
#SBATCH --mem=50g
#SBATCH --tmp=25g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu


cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS
module load R

export PATH=/common/software/install/spack/linux-centos7-ivybridge/gcc-8.2.0/r-4.2.2-vp7tydeosl55o3d5hp5plulp6evljtbp/bin:$PATH


Rscript 9PARSIMONY_LOOPED_AF.r
