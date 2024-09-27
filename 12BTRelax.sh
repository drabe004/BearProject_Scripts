#!/bin/bash       
#SBATCH --time=130:00:00
#SBATCH --ntasks=25
#SBATCH --mem=250g
#SBATCH --tmp=150g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=drabe004@umn.edu


# Load necessary modules
module use /common/software/modulefiles/manual/common
module load hyphy/2.5.53

# Directory containing alignment and tree files
input_dir=/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Clean_Alignments/SUBSET

# Output directory for results
output_dir=/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Relax_results

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"


# Loop through alignment files
for alignment_file in "$input_dir"/*_clean.fasta; do
    # Extract prefix from alignment filename
    alignment_prefix=$(basename "$alignment_file" _clean.fasta)
    
    # Construct corresponding tree filename
    tree_file="$input_dir/${alignment_prefix}_clean_FGBG.tre"

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
