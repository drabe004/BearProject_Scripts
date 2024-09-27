#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --mem=80g
#SBATCH --tmp=40g
#SBATCH -p astyanax
#SBATCH --mail-type=ALL
#SBATCH --mail-user=drabe004@umn.edu

# Absolute path to the directory where files are copied
input_directory="/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/OldIntermediates/Renamed_output_ALL_HG/"

# Log file to report pairs that do not match
log_file="$input_directory/do_they_match.txt"

# Function to extract the common prefix from a filename
get_common_prefix() {
    basename "$1" | cut -d_ -f1
}

# Function to read and compare the headers in two files
compare_headers() {
    file1="$1"
    file2="$2"

    prefix=$(get_common_prefix "$file1")

    # Create an associative array to store the headers from file1
    declare -A headers1_dict

    # Read the headers from file1 and populate the associative array
    while IFS= read -r header; do
        headers1_dict["$header"]=1
    done < <(grep "^>.*$" "$file1")

    # Check for header matches in file2 and store non-matching headers in an array
    mismatched_headers=()
    while IFS= read -r header; do
        if [ -z "${headers1_dict["$header"]}" ]; then
            mismatched_headers+=("$header")
        fi
    done < <(grep "^>.*$" "$file2")

    # Print the result to the log file
    if [ ${#mismatched_headers[@]} -gt 0 ]; then
        echo "Mismatch in headers for pair: $prefix" >> "$log_file"
        echo "Headers in $file1 THAT HAVE NO MATCH:" >> "$log_file"
        printf '%s\n' "${mismatched_headers[@]}" >> "$log_file"
        echo >> "$log_file"
    fi
}

# Ensure the log file exists and is empty
echo -n > "$log_file"

# Find files that have the same prefix
cd "$input_directory" || exit

for file1 in *_*.fasta; do
    for file2 in "${file1%%_*}"_*".fasta"; do
        if [ "$file1" != "$file2" ]; then
            compare_headers "$file1" "$file2"
        fi
    done
done