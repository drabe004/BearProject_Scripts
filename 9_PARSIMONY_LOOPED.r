# Load libraries
.libPaths(new = '/panfs/jay/groups/26/mcgaughs/drabe004/R/x86_64-pc-linux-gnu-library/4.0')
library(phytools)
library(maps)
library(ape)
library(phangorn)
library(castor)
library(optparse)

# ---------------------------
# Define command-line options
# ---------------------------
option_list <- list(
    make_option(c("-i", "--input"), type="character", help="Main input directory with subdirectories of trees"),
    make_option(c("-f", "--foreground"), type="character", help="Foreground taxa file")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

if (is.null(opt$input) || is.null(opt$foreground)) {
    print_help(opt_parser)
    stop("Both --input and --foreground must be supplied.", call.=FALSE)
}

main_input_directory <- opt$input
foreground_file <- opt$foreground

# ---------------------------
# Main Code
# ---------------------------

# Get list of foreground taxa
foreground_taxa <- readLines(foreground_file)
foreground_taxa <- gsub("^\\s+|\\s+$", "", foreground_taxa)

# List subdirectories
subdirectories <- list.dirs(main_input_directory, full.names=TRUE, recursive=FALSE)

# Iterate
for (subdir in subdirectories) {
    tree_files <- list.files(subdir, pattern="\\.tre$", full.names=TRUE)
    
    for (tree_file in tree_files) {
        tree <- read.tree(tree_file)
        filename <- tools::file_path_sans_ext(basename(tree_file))
        
        all_taxa <- tree$tip.label
        trait_states <- data.frame(Species = all_taxa, TraitState = "Background")
        trait_states$TraitState[trait_states$Species %in% foreground_taxa] <- "Foreground"
        trait_csv_file <- file.path(subdir, paste0(filename, "_Species_TraitStates.csv"))
        write.csv(trait_states, file=trait_csv_file, row.names=FALSE)
        
        trait_data <- read.csv(trait_csv_file)
        trait_data$TraitState <- as.integer(trait_data$TraitState == "Background") + 1
        tip_states <- trait_data$TraitState
        
        asr_result <- asr_max_parsimony(tree, tip_states, 2, "all_equal", 0, TRUE, TRUE)
        
        output_subdirectory <- file.path(subdir, "Output")
        dir.create(output_subdirectory, showWarnings=FALSE)
        likelihoods_csv_file <- file.path(output_subdirectory, paste0(filename, "_Ancestral_Likelihoods.csv"))
        write.csv(asr_result$ancestral_likelihoods, file=likelihoods_csv_file, row.names=FALSE)
        
        # Node labels
        for (i in 1:length(asr_result$ancestral_states)) {
            if (asr_result$ancestral_states[i] == 2) tree$node.label[i] <- "{Background}"
            if (asr_result$ancestral_states[i] == 1) tree$node.label[i] <- "{Foreground}"
        }
        tree$node.label[tree$node.label == "{Background}"] <- ""
        
        # Tip labels
        for (i in 1:length(tree$tip.label)) {
            if (tree$tip.label[i] %in% foreground_taxa) {
                tree$tip.label[i] <- paste0(tree$tip.label[i], "{Foreground}")
            }
        }
        
        output_tree_file <- file.path(output_subdirectory, paste0(filename, "_FGBG.tre"))
        write.tree(tree, file=output_tree_file)
    }
}
