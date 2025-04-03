#!/bin/bash       
#SBATCH --time=470:00:00
#SBATCH --ntasks=120
#SBATCH --mem=450g
#SBATCH --tmp=250G
#SBATCH --mail-type=ALL 
#SBATCH --mail-user=your email


###This will run hyphy on pairs of trees and alignments in a directory as long as they have the same prefix for example, GENE1_blahblah.fasta and GENE1_blahblahblah.tre. 
### This is set to --srv Yes which accounts for synonymous rate variation and --branches Foreground which is created by the previous r script designating FG branches. Please see Hyphy documentation for notes on how to change flags as needed to support nested tests (hypothesis free runs, and models accounting for double and triple nt changes) 

# Load necessary modules
module use /common/software/modulefiles/manual/common
module load hyphy/2.5.53


# Set the number of CPU cores per task
export SLURM_CPUS_PER_TASK=1

# Directory containing alignment and tree files
input_dir=/dir/to/your/cleaned/codon/alignments/and/parsimony/designated/foreground/trees
# Directory for output files
output_dir=/directory/to/your/output

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through alignment files
for alignment_file in "$input_dir"/*_clean.fasta; do
    # Extract prefix from alignment filename
    alignment_prefix=$(basename "$alignment_file"_*.fasta)
    
    # Construct corresponding tree filename
    tree_file="$input_dir/${alignment_prefix}_*.tre"
    
    # Construct output filename
    output_file="$output_dir/${alignment_prefix}_BUSTED"
    
    # Check if the tree file exists
    if [ -f "$tree_file" ]; then
        ############ Run a Foreground/Background test of selection ######################
        hyphy -1 busted --alignment "$alignment_file" --srv Yes --tree "$tree_file" --branches Foreground > "$output_file"
        ##############################################################################################################
    else
        echo "Tree file for $alignment_file not found."
    fi
done


################################# NESTED TEST OPTIONS #######################################################################
# RUN A HYPOTEHSIS FREE RUN (All branches are foreground)
        hyphy -1 busted --alignment "$alignment_file" --srv Yes  --tree "$tree_file"  > "$output_file"


