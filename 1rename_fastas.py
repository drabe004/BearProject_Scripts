#!/usr/bin/env python3

import os
import re
import argparse

# Argument parsing
parser = argparse.ArgumentParser(description="Process FASTA files.")
parser.add_argument("input_directory", help="Input directory containing FASTA files")
parser.add_argument("output_directory", help="Output directory to store modified files")
args = parser.parse_args()

# Validate input directory existence
if not os.path.exists(args.input_directory):
    print(f"Error: Input directory '{args.input_directory}' not found.")
    exit(1)

# Create the output directory if it doesn't exist
os.makedirs(args.output_directory, exist_ok=True)

# Species names to delete
species_to_delete = ["Bos indicus x Bos taurus", "Canis lupus dingo"]

# Function to check if the line contains any of the species names to delete
def contains_species_to_delete(line):
    return any(species in line for species in species_to_delete)

# Process all FASTA files in the input directory
for input_file in os.listdir(args.input_directory):
    if input_file.endswith(".fasta"):
        input_file_path = os.path.join(args.input_directory, input_file)
        output_file = os.path.join(args.output_directory, f"{os.path.splitext(input_file)[0]}_RENAMED.fasta")
        
        with open(input_file_path, "r") as infile, open(output_file, "w") as outfile:
            deleting_entry = False
            for line in infile:
                line = line.strip()
                if line.startswith(">"):
                    if contains_species_to_delete(line):
                        deleting_entry = True
                    else:
                        header_match = re.search(r"([A-Za-z]+\ [A-Za-z]+(_[A-Za-z]+)?)", line)
                        if header_match:
                            species_name = header_match.group(1).replace(" ", "_")
                            outfile.write(f">{species_name}\n")
                        deleting_entry = False
                else:
                    if not deleting_entry:
                        outfile.write(f"{line}\n")
        
        print(f"Headers modified and written to '{output_file}'.")
