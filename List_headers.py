import os
import argparse

# Function to extract headers from a .fasta file
def extract_headers(file_path):
    headers = []
    with open(file_path, 'r') as f:
        for line in f:
            if line.startswith('>'):
                headers.append(line.strip()[1:])  # Remove the '>' character
    return headers

# Parse arguments
parser = argparse.ArgumentParser(description="Extract unique headers from all .fasta files in a directory.")
parser.add_argument("directory", help="Directory containing .fasta files")
parser.add_argument("-o", "--output_file", default="all_headers.txt", help="Output file name (default: all_headers.txt)")
args = parser.parse_args()

# Get a list of all .fasta files in the directory
fasta_files = [f for f in os.listdir(args.directory) if f.endswith('.fasta')]

# Extract headers from each .fasta file
all_headers = []
for fasta_file in fasta_files:
    file_path = os.path.join(args.directory, fasta_file)
    headers = extract_headers(file_path)
    all_headers.extend(headers)

# Remove duplicates and sort the headers
unique_headers = sorted(set(all_headers))

# Write the unique headers to a text file
with open(args.output_file, 'w') as f:
    for header in unique_headers:
        f.write(header + '\n')

print(f"Extracted {len(unique_headers)} unique headers and saved them to {args.output_file}")
