#!/bin/bash       
#SBATCH --time=130:00:00
#SBATCH --ntasks=25
#SBATCH --mem=250g
#SBATCH --tmp=150g
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=youremail

####This script runs the HYPHY program RELAX on a set of alignments and tree files with matching prefixes "Gene1_blahblah.fasta" and "Gene1_blahblah.tre" and outputs results to a separarate directory 

# Load necessary modules
module use /common/software/modulefiles/manual/common
module load hyphy/2.5.53

# Directory containing alignment and tree files
input_dir=your/clean/codon/alignments

# Output directory for results
output_dir=your/Relax/results

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"


# Loop through alignment files
for alignment_file in "$input_dir"/_*.fasta; do
    # Extract prefix from alignment filename
    alignment_prefix=$(basename "$alignment_file"_*.fasta)
    
    # Construct corresponding tree filename
    tree_file="$input_dir/${alignment_prefix}_*.tre"

 # Construct output filename
    output_file="$output_dir/${alignment_prefix}_relax"
    
    
    # Check if the tree file exists
    if [ -f "$tree_file" ]; then
        # Run the hyphy command
        hyphy -1 relax --alignment "$alignment_file" --srv Yes  --tree "$tree_file" --test Foreground >"$output_file"
    else
        echo "Tree file for $alignment_file not found."
    fi
done
