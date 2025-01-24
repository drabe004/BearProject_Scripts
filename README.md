# BearProject_Scripts
1) A set of scripts that will process NCBI ortholog database sequences for selection analysis in Hyphy
2) An R script for running RERconverge on 19k mammalian gene trees from 120 mammal genomes 



## Script Collection for FASTA, Alignment File Processing, and Phylogenetic Analysis

## Overview

## This repository contains scripts designed for various aspects of genetic data analysis, including renaming headers, pruning trees, checking for mismatches, assigning foreground with parsimony, and extracting results from analyses like BUSTED and RELAX.

## Initial Inputs:
## 1. NCBI FASTA lists of RefSeq sequences (one sequence per species) from the NCBI ortholog database (.fasta files).
## 2. Corresponding COBALT protein alignments (.aln) from the NCBI ortholog database.
## 3. An input Species Topology including all species desired for final selection analyses

## Table of Contents

## 1. 1rename_fastas.py
## 2. 1RENAME_fastas_py.sh
## 3. 2RENAME_alns.sh
## 4. 3CopyPairsToNewDir.sh
## 5. 4Check_matching_headers.sh
## 6. 5.5DeleteRemainingMismatches.py
## 7. 5.5DeleteRemainingMismatches.sh
## 8. 5FIX_Mismatches.sh
## 9. 6REORDER_Sequences.sh
## 10. 7.5CLEANUP_ALNS_LOOP.py
## 11. 7.5CLEANUP_ALNS_LOOP.sh
## 12. 7Run_PAL2NAL_loop.sh
## 13. 8WriteTrees.py
## 14. 8WriteTrees.sh
## 15. 9PARSIMONY_LOOPED.r
## 16. 9PARSIMONY_LOOPED.sh
## 17. 10BUSTED.sh
## 18. 10BUSTED_BO.sh
## 19. 11BUSTED_HF.sh
## 20. 12BTRelax.sh
## 21. 12BTORelax_BO.sh
## 22. 14Extract_resultsBUSTED.py
## 23. 14Extract_resultsBUSTED_HF.py
## 24. 14Extract_resultsRELAX.py
## 25. 15Extract_Unrounded_pvalues.py
## 26. List_headers.py
## 27. ListHeaders.sh
## 28. RERconverge R script to run several binary analysis on 19k gene trees from 120 mammal genomes 

# 1. 1rename_fastas.py
## Description: Processes FASTA files by renaming headers and removing subspecies information from organism names.
Usage:
  python3 1rename_fastas.py input_directory output_directory

# 2. 1RENAME_fastas_py.sh
## Description: SLURM script that runs `1rename_fastas.py` to rename headers in FASTA files using HPC resources.
Usage:
  sbatch 1RENAME_fastas_py.sh

# 3. 2RENAME_alns.sh
## Description: Renames organisms in alignment (.aln) files to match species names in the corresponding FASTA files.
Usage:
  sbatch 2RENAME_alns.sh

# 4. 3CopyPairsToNewDir.sh
## Description: Copies renamed FASTA and alignment files into a single output directory for easier management.
Usage:
  sbatch 3CopyPairsToNewDir.sh

# 5. 4Check_matching_headers.sh
## Description: Compares headers between paired FASTA and alignment files, logging any mismatches found between them.
Usage:
  sbatch 4Check_matching_headers.sh

# 6. 5.5DeleteRemainingMismatches.py
## Description: Removes mismatched sequences between paired FASTA and alignment files by deleting sequences without matching headers.
Usage:
  python3 5.5DeleteRemainingMismatches.py input_directory output_directory

# 7. 5.5DeleteRemainingMismatches.sh
## Description: SLURM script that runs `5.5DeleteRemainingMismatches.py` on HPC.
Usage:
  sbatch 5.5DeleteRemainingMismatches.sh

# 8. 5FIX_Mismatches.sh
## Description: Corrects specific species name mismatches in the headers of FASTA files (e.g., renaming `Neovison_vison` to `Neogale_vison`).
Usage:
  sbatch 5FIX_Mismatches.sh

# 9. 6REORDER_Sequences.sh
## Description: Reorganizes sequences in FASTA files to ensure consistent order for downstream analyses.
Usage:
  sbatch 6REORDER_Sequences.sh

# 10. 7.5CLEANUP_ALNS_LOOP.py
## Description: Processes alignment files by replacing stop codons with gaps, trimming alignments, and removing sequences with high gap percentages.
Usage:
  python3 7.5CLEANUP_ALNS_LOOP.py input_directory output_directory gap_threshold debug_logfile

# 11. 7.5CLEANUP_ALNS_LOOP.sh
## Description: SLURM script that runs `7.5CLEANUP_ALNS_LOOP.py` for batch processing.
Usage:
  sbatch 7.5CLEANUP_ALNS_LOOP.sh

# 12. 7Run_PAL2NAL_loop.sh
## Description: Runs PAL2NAL to convert protein aln and DNA seq to ensure an in-frame codon alignment 
Usage:
  sbatch 7Run_PAL2NAL_loop.sh

# 13. 8WriteTrees.py
## Description: Generates pruned phylogenetic tree files based on species found in FASTA alignments, matching them to a master tree (timetree).
Usage:
  python3 8WriteTrees.py master_tree_file fasta_directory

# 14. 8WriteTrees.sh
## Description: SLURM script that runs `8WriteTrees.py` on an HPC cluster.
Usage:
  sbatch 8WriteTrees.sh

# 15. 9PARSIMONY_LOOPED.r
## Description: assigns foreground species and internal nodes trees using parsimony. Script will use a single list of foreground taxa to write a custom tree for each alignment. Output is suitable for hyphy.  
Usage:
  Rscript 9PARSIMONY_LOOPED.r

# 16. 9PARSIMONY_LOOPED.sh
## Description: SLURM script to run the parsimony analysis in `9PARSIMONY_LOOPED.r`.
Usage:
  sbatch 9PARSIMONY_LOOPED.sh

# 17. 10BUSTED.sh
## Description: Runs the BUSTED test for episodic selection on specified alignment and tree files.
Usage:
  sbatch 10BUSTED.sh

# 18. 10BUSTED_BO.sh
## Description: Runs the BUSTED test on background/foreground models.
Usage:
  sbatch 10BUSTED_BO.sh

# 19. 11BUSTED_HF.sh
## Description: Runs the BUSTED analysis on hand-edited alignments to detect episodic selection.
Usage:
  sbatch 11BUSTED_HF.sh

# 20. 12BTRelax.sh
## Description: Runs the RELAX test for relaxed selection on alignment and tree files.
Usage:
  sbatch 12BTRelax.sh

# 21. 12BTORelax_BO.sh
## Description: Runs the RELAX test on background/foreground models (bears only)
Usage:
  sbatch 12BTORelax_BO.sh

# 22. 14Extract_resultsBUSTED.py
## Description: Extracts p-values from BUSTED test results and saves them in a summary CSV file.
Usage:
  python3 14Extract_resultsBUSTED.py

# 23. 14Extract_resultsBUSTED_HF.py
## Description: Extracts p-values from BUSTED-HF results and saves them in a summary CSV file.
Usage:
  python3 14Extract_resultsBUSTED_HF.py

# 24. 14Extract_resultsRELAX.py
## Description: Extracts p-values and accompanying sentences from RELAX test results and outputs them to a CSV file.
Usage:
  python3 14Extract_resultsRELAX.py

# 25. 15Extract_Unrounded_pvalues.py
## Description: Extracts unrounded p-values from BUSTED JSON result files and writes them to a CSV file.
Usage:
  python3 15Extract_Unrounded_pvalues.py <directory_path> <output_file>

# 26. List_headers.py
## Description: Extracts and lists all unique headers from FASTA files in a given directory and saves them to a text file.
Usage:
  python3 List_headers.py

# 27. ListHeaders.sh
## Description: SLURM script to run `List_headers.py` and list headers from FASTA files on HPC.
Usage:
  sbatch ListHeaders.sh
