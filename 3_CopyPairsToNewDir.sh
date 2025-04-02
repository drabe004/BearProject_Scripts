#!/bin/bash -l        
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH --mail-type=ALL
#SBATCH --mail-user= youremail.com

cd /your/path


# Input directories to copy
input_dir1="output_renamed_refseq"
input_dir2="output_renamed_alns"

# Output directory to store all contents
output_directory="Renamed_output_ALL"


# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Copy the contents of input_dir1 to output_directory
cp -r "$input_dir1"/* "$output_directory/"

# Copy the contents of input_dir2 to output_directory (overwrite if necessary)
cp -r "$input_dir2"/* "$output_directory/"
