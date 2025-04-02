#!/bin/bash -l        
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --mem=20g
#SBATCH --tmp=10g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail

########################################## Alignment Cleaning Pipeline
########################################## Make sure you understand what this is doing, adjust thresholds as needed 
#
# Workflow:
#   1. Sequences are truncated at the first in-frame stop codon (TAA, TAG, TGA).
#   2. The alignment is trimmed:
#         - All columns (codons) before the first codon where ≥ INITIAL_THRESHOLD 
#           of sequences have data (no gaps) are removed.
#         - If no codon meets INITIAL_THRESHOLD, fallback to SECONDARY_THRESHOLD.
#   3. Sequences are then filtered:
#         - Any sequence with a gap proportion higher than GAP_THRESHOLD is removed.
#
# Output: Cleaned alignment

# ----------- Input -----------

# Directory containing input FASTA alignments
INPUT_DIR="input_alignments"

# Directory where cleaned alignments will be saved
OUTPUT_DIR="cleaned_alignments"

# Log file for messages and warnings
LOG_FILE="alignment_cleaning.log"

# INITIAL TRIM THRESHOLD
# Proportion of sequences that must have a codon present (left to right) to be considered the first codon in the alignment
# e.g. the first codon present in 90% of sequences (left to right) will be the start of the alignment and all sequence upstream of that will be trimmed
INITIAL_THRESHOLD=0.9

# SECONDARY TRIM THRESHOLD (fallback)
# If no codon meets INITIAL_THRESHOLD, this relaxed threshold is used.
# e.g., 0.75 = 75% of sequences must have data to accept a the first codon.
SECONDARY_THRESHOLD=0.75

# GAP THRESHOLD (sequence removal)
# Sequences with < this fraction of sites present are REMOVED from the alignment.
# e.g., 0.75 means sequences with >25% gaps are discarded.
GAP_THRESHOLD=0.75

############################################################################# RUN IT #################################################
cd  path/to/your/folder 
 
module load python3


python3 7.5_CLEANUP_ALNS_LOOP.py \
    "$INPUT_DIR" \
    "$OUTPUT_DIR" \
    "$GAP_THRESHOLD" \
    "$INITIAL_THRESHOLD" \
    "$SECONDARY_THRESHOLD" \
    "$LOG_FILE"

echo "✅ Alignment cleaning complete. Results saved to: $OUTPUT_DIR"







