#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu


cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS 

# Input directory containing FASTA files
input_dir="Renamed_output_ALL"

# Run the sorting command for all FASTA files in the input directory
for fasta_file in "$input_dir"/*.fasta; do
    # Check if the file is a regular file (not a directory)
    if [ -f "$fasta_file" ]; then
        # Run the sorting command
        sorted_output=$(sed 's/^>/\x00&/' "$fasta_file" | sort -z | tr -d '\0')

        # Save the sorted content back to the original file
        echo "$sorted_output" > "$fasta_file"
    fi
done