import os

# Function to extract headers from a .fasta file
def extract_headers(file_path):
    headers = []
    with open(file_path, 'r') as f:
        for line in f:
            if line.startswith('>'):
                headers.append(line.strip()[1:])  # Remove the '>' character
    return headers

# Get a list of all .fasta files in the directory
directory = '/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/PAL2NAL_alns'
fasta_files = [f for f in os.listdir(directory) if f.endswith('.fasta')]

# Extract headers from each .fasta file
all_headers = []
for fasta_file in fasta_files:
    file_path = os.path.join(directory, fasta_file)
    headers = extract_headers(file_path)
    all_headers.extend(headers)

# Remove duplicates and sort the headers
unique_headers = sorted(set(all_headers))

# Write the unique headers to a text file
output_file = 'all_headers.txt'
with open(output_file, 'w') as f:
    for header in unique_headers:
        f.write(header + '\n')

print(f"Extracted {len(unique_headers)} unique headers and saved them to {output_file}")
