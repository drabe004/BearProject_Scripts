#!/bin/bash       
#SBATCH -p astyanax
#SBATCH --time=470:00:00
#SBATCH --ntasks=120
#SBATCH --mem=450g
#SBATCH --tmp=250G
#SBATCH --mail-type=ALL 
#SBATCH --mail-user=drabe004@umn.edu

# Load necessary modules
module use /common/software/modulefiles/manual/common
module load hyphy/2.5.53


# Set the number of CPU cores per task
export SLURM_CPUS_PER_TASK=1

# Directory containing alignment and tree files
input_dir=/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Clean_Alignments/
# Directory for output files
output_dir=/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/BUSTED_FGBG_OUT

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through alignment files
for alignment_file in "$input_dir"/*_clean.fasta; do
    # Extract prefix from alignment filename
    alignment_prefix=$(basename "$alignment_file" _clean.fasta)
    
    # Construct corresponding tree filename
    tree_file="$input_dir/${alignment_prefix}_clean_FGBG.tre"
    
    # Construct output filename
    output_file="$output_dir/${alignment_prefix}_BUSTED"
    
    # Check if the tree file exists
    if [ -f "$tree_file" ]; then
        # Run the hyphy command with the correct number of CPU cores and redirect output
        hyphy -1 busted --alignment "$alignment_file" --srv Yes--tree "$tree_file" --branches Foreground > "$output_file"
    else
        echo "Tree file for $alignment_file not found."
    fi
done
