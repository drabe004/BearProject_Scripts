#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=youremail


# Absolute path to the directory where files are copied
input_directory="/path/to/Renamed_output_ALL"

# Function to replace text in .fasta files
replace_text_in_files() {
    directory="$1"

    # Check if the input directory exists
    if [ ! -d "$directory" ]; then
        echo "Error: Input directory not found."
        exit 1
    fi

    # Loop through all .fasta files in the directory
    for file in "$directory"/*.fasta; do
        # Check if the file is a regular file
        if [ -f "$file" ]; then
            # Use sed to replace "Neovison_vison" with "Neogale_vison" and save the changes in a temporary file
            sed 's/Neovison_vison/Neogale_vison/g' "$file" > "${file}.tmp"

            # Replace the original file with the temporary file
            mv "${file}.tmp" "$file"
        fi
    done
}

# Call the function to replace text in .fasta files within the input directory
replace_text_in_files "$input_directory"
