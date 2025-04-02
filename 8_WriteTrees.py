from Bio import Phylo
from Bio import SeqIO
import os
import argparse
import copy
import subprocess

def prune_tree(tree, species_list):
    for leaf in tree.get_terminals():
        if leaf.name not in species_list:
            tree.prune(leaf)

def main():
    parser = argparse.ArgumentParser(description="Generate pruned tree files based on species in FASTA alignments.")
    parser.add_argument("master_tree", help="Path to the master tree file (in Newick format)")
    parser.add_argument("fasta_directory", help="Path to the directory containing FASTA alignment files")
    args = parser.parse_args()

    master_tree_file = args.master_tree
    fasta_directory = args.fasta_directory

    # Read the master tree
    master_tree = Phylo.read(master_tree_file, "newick")

    # List all FASTA files in the directory
    fasta_files = [file for file in os.listdir(fasta_directory) if file.endswith(".fasta")]

    for fasta_file in fasta_files:
        fasta_path = os.path.join(fasta_directory, fasta_file)
        tree_output_path = os.path.join(fasta_directory, f"{os.path.splitext(fasta_file)[0]}.tre")

        # Parse the FASTA file to extract species
        species_list = [record.id for record in SeqIO.parse(fasta_path, "fasta")]

        # Prune the master tree
        pruned_tree = copy.deepcopy(master_tree)
        prune_tree(pruned_tree, species_list)

    
        # Write the pruned tree to a new file
        Phylo.write(pruned_tree, tree_output_path, "newick")

        # Remove branch lengths using sed
        subprocess.run(["sed", "-i", "-E", "s/:[0-9]+\\.?[0-9]*//g", tree_output_path])

if __name__ == "__main__":
    main()
