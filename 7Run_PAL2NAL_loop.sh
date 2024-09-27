#!/bin/bash -l        
#SBATCH --time=96:00:00
#SBATCH --ntasks=20
#SBATCH --mem=400g
#SBATCH --tmp=200g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu

cd /panfs/jay/groups/26/mcgaughs/drabe004/BEARS

# Define input and output directories
input_dir="Renamed_output_ALL"
output_dir="PAL2NAL_alns"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through the protein files in the input directory
for protein_file in "$input_dir"/*prot*.fasta; do
    # Get the prefix of the protein file (the part before the first underscore)
    prefix=$(basename "$protein_file" | cut -d '_' -f 1)

    # Find the corresponding DNA file with the same prefix
    dna_file=$(find "$input_dir" -maxdepth 1 -name "${prefix}_refseq*.fasta" | grep -v 'prot' | head -n 1)

    # Run pal2nal if a matching DNA file is found
    if [ -n "$dna_file" ]; then
        output_file="${output_dir}/${prefix}_PAL2NAL.fasta"
        ./pal2nal.v14/pal2nal.pl "$protein_file" "$dna_file" -output fasta -nomismatch > "$output_file"
    else
        echo "No matching DNA file found for $protein_file"
    fi
done