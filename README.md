# 🐻 BEARS Pipeline  
**Batch Evolutionary Analysis of Robust Sequences**

Scripts for FASTA and Alignment File Processing, Phylogenetic Tree Manipulation, and Selection Tests (BUSTED / RELAX) on HPC clusters.

---

## 📖 Overview

This repository provides a modular pipeline for:
- Preparing orthologous gene datasets
- Cleaning FASTA and alignment files
- Pruning species trees
- Running selection tests (BUSTED and RELAX)
- Extracting and summarizing results

The pipeline is optimized for large phylogenomic datasets and high-performance computing environments.

---

## ✨ Inputs

1. NCBI RefSeq FASTA files (one per species) from the NCBI ortholog database.
2. COBALT protein alignments (.aln).
3. A rooted species tree including all target species for selection analyses.

---

## 🛠️ Dependencies

- Python ≥ 3.7  
- R ≥ 4.0  
- HyPhy (for BUSTED and RELAX)
- PAL2NAL  
- SLURM scheduler (for cluster usage)  
- Standard Unix utilities (bash, awk, sed, etc.)

---

## Workflow Overview

| Step | Description |
|------|-------------|
| Rename FASTA & Alignment headers | Standardize species names across datasets |
| Check & Fix mismatches | Ensure FASTA and alignment headers match |
| Cleanup Alignments | Remove bad sequences, stop codons, and gaps |
| Convert Alignments | Generate codon alignments using PAL2NAL |
| Prune Trees | Match trees to sequence alignments |
| Assign Foreground | Create trees for selection analysis with foreground clades |
| Selection Analyses | Run BUSTED and RELAX (HyPhy) |
| Extract Results | Summarize results into CSV tables |



## Table of Contents

### FASTA and Alignment Preparation
1. `1_rename_fastas.py` — Rename FASTA headers
2. `1_RENAME_fastas_py.sh` — SLURM wrapper for renaming FASTA headers
3. `2_RENAME_alns.py` — Rename alignment files to match FASTA headers
4. `2_RENAME_alns.sh` — SLURM wrapper for alignment renaming
5. `3_CopyPairsToNewDir.sh` — Copy FASTA/ALN pairs into a new directory
6. `4_Check_matching_headers.sh` — Check for header mismatches between FASTA and ALN files
7. `5.5_DeleteRemainingMismatches.py` — Remove sequences without matching headers
8. `5.5_DeleteRemainingMismatches.sh` — SLURM wrapper for deleting mismatches
9. `5_FIX_Mismatches.sh` — Fix specific header mismatches (e.g., species name corrections)
10. `6_REORDER_Sequences.sh` — Reorder sequences within FASTA files

### Alignment Cleanup & Codon Conversion
11. `7.5_CLEANUP_ALNS_LOOP.py` — Clean up alignments (stop codons, gaps, trimming)
12. `7.5_CLEANUP_ALNS_LOOP.sh` — SLURM wrapper for alignment cleanup
13. `7_Run_PAL2NAL_loop.sh` — Codon-align using PAL2NAL

### Tree Processing
14. `8_WriteTrees.py` — Prune species tree to match alignments
15. `8_WriteTrees.sh` — SLURM wrapper for tree pruning
16. `9_PARSIMONY_LOOPED.r` — Assign foreground species using parsimony
17. `9_PARSIMONY_LOOPED.sh` — SLURM wrapper for parsimony-based foreground assignment

### Selection Analyses
18. `10_BUSTED.sh` — Run BUSTED selection test
19. `11_Relax.sh` — Run RELAX selection test

### Result Extraction
20. `12_extractResultsBUSTED.py` — Extract BUSTED p-values into CSV
21. `12_extractResultsBUSTED.sh` — SLURM wrapper for BUSTED extraction
22. `13_Extract_resultsRELAX.py` — Extract RELAX results into CSV
23. `13_Extract_resultsRELAX.sh` — SLURM wrapper for RELAX extraction
24. `14_Extract_Unrounded_pvalues.py` — Extract unrounded p-values from BUSTED JSON
25. `14_Extract_unrounded_pvalues.sh` — SLURM wrapper for unrounded p-value extraction

### Utility Scripts
####- you can use this to generate a master species tree/topology to use as input for 8_writetrees.sh/py timetree.org will generate a tree for most species. You can manually add branches or rename species/subspecies in R using add.tip to include all species in your dataset. 
26. `List_headers.py` — Extract all unique headers from FASTA files-
27. `ListHeaders.sh` — SLURM wrapper for header extraction

### Visualization and Analysis
28. `BearMetaboliteVisualizationCode.R` — Metabolite visualization code for bear datasets

###RERConverge Analysis script ##########################
30. `RER_Bears_19kgenes_10kPerms.R` — RERconverge analysis script for 19k genes and 10k permutations, requires trees file (gene trees for 19610 genes from 120 mammalian genomes available here: https://doi.org/10.1101/2024.10.15.618548

### Documentation & License
30. `README.md` — Documentation (this file)
31. `LICENSE` — License file



## 📚 Citations

If you use this pipeline in your research, please cite the original methods and associated tools:

- **BUSTED**  
  Murrell B, et al. (2015). *Gene-wide identification of episodic selection*.  
  *Molecular Biology and Evolution*, **32**(5): 1365–1371.  
  https://doi.org/10.1093/molbev/msv035

- **RELAX**  
  Wertheim JO, et al. (2015). *RELAX: Detecting relaxed selection in a phylogenetic framework*.  
  *Molecular Biology and Evolution*, **32**(3): 820–832.  
  https://doi.org/10.1093/molbev/msu400

- **PAL2NAL**  
  Suyama M, Torrents D, Bork P. (2006). *PAL2NAL: robust conversion of protein sequence alignments into corresponding codon alignments*.  
  *Nucleic Acids Research*, **34**: W609–W612.  
  https://doi.org/10.1093/nar/gkl315

- **This Pipeline**  
  Please cite this repository if you adapt or build upon these custom scripts.  
  📄 *Original Publication:*  
  https://www.biorxiv.org/content/10.1101/2024.10.15.618548v1


NOTES: 
Designed for large-scale datasets.
Robust to missing data and small alignment mismatches.
Logs are created automatically in each .sh step.
Scripts assume UNIX-style paths and directory structures.


