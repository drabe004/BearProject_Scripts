
# Set library path
.libPaths(new = '/panfs/jay/groups/26/mcgaughs/drabe004/R/x86_64-pc-linux-gnu-library/4.0')
library(phytools)
library(maps)
library(ape)
library(phangorn)
library(castor)

# Main input directory (contains subdirectories with tree files)
   ########################CHANGEINPUT############################
main_input_directory <- "/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Hand_Edited_Alignments/"

# List all subdirectories in the main input directory
subdirectories <- list.dirs(main_input_directory, full.names = TRUE, recursive = FALSE)

# Iterate through each subdirectory
for (subdir in subdirectories) {
    # Read the list of foreground taxa and clean it up
    ########################CHANGEINPUT############################
    foreground_taxa <- readLines("/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Foregound_taxa.txt")
    foreground_taxa <- gsub("^\\s+|\\s+$", "", foreground_taxa)

    # List all tree files in the current subdirectory
    tree_files <- list.files(subdir, pattern = "\\.tre$", full.names = TRUE)
  
    # Iterate through each tree file in the current subdirectory
    for (tree_file in tree_files) {
        # Read and prepare the tree file with {Foreground} tip labels
        tree <- read.tree(tree_file)
    
        # Get the filename without the path and extension
        filename <- basename(tree_file)
        filename <- gsub(".tre$", "", filename)
    
        # Create and write the trait states data to CSV
        all_taxa <- tree$tip.label
        trait_states <- data.frame(Species = all_taxa, TraitState = "Background")
        trait_states$TraitState[trait_states$Species %in% foreground_taxa] <- "Foreground"
        trait_csv_file <- file.path(subdir, paste0(filename, "_Species_TraitStates.csv"))
        write.csv(trait_states, file = trait_csv_file, row.names = FALSE)
    
        # Read and prepare the trait data
        trait_data <- read.csv(trait_csv_file)
        trait_data$TraitState <- as.integer(trait_data$TraitState == "Background") + 1
        tip_states <- trait_data$TraitState
    
        # Perform ancestral state reconstruction using asr_max_parsimony
        Nstates <- 2
        transition_costs <- "all_equal"
        edge_exponent <- 0
        weight_by_scenarios <- TRUE
        check_input <- TRUE
        asr_result <- asr_max_parsimony(tree, tip_states, Nstates, 
                                        transition_costs, edge_exponent,
                                        weight_by_scenarios, check_input)
    
        # Write ancestral likelihoods to CSV in a subdirectory
        output_subdirectory <- file.path(subdir, "Output")
        dir.create(output_subdirectory, showWarnings = FALSE)
        likelihoods_csv_file <- file.path(output_subdirectory, paste0(filename, "_Ancestral_Likelihoods.csv"))
        write.csv(asr_result$ancestral_likelihoods, file = likelihoods_csv_file, row.names = FALSE)
    
        # Add node labels to the tree based on ancestral states and remove {Background} labels
        for (i in 1:length(asr_result$ancestral_states)) {
            if (asr_result$ancestral_states[i] == 2) {
                tree$node.label[i] <- "{Background}"
            } else if (asr_result$ancestral_states[i] == 1) {
                tree$node.label[i] <- "{Foreground}"
            }
        }
    
        for (i in 1:length(tree$node.label)) {
            if (tree$node.label[i] == "{Background}") {
                tree$node.label[i] <- ""
            }
        }
    
         # Read the list of foreground tips and add "{Foreground}" labels again for clarity
        ########################CHANGEINPUT############################
        foreground_tips <- readLines("/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/Foregound_taxa.txt")
        for (i in 1:length(tree$tip.label)) {
            if (tree$tip.label[i] %in% foreground_tips) {
                tree$tip.label[i] <- paste0(tree$tip.label[i], "{Foreground}")
            }
        }
    
        # Write the modified tree to a new file in the respective subdirectory's output folder
        ########################CHANGE OUTPUT############################
        output_tree_file <- file.path(output_subdirectory, paste0(filename, "_FGBG.tre"))
        write.tree(tree, file = output_tree_file)
    }
}