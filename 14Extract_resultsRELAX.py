import os
import re  # Import the re module

# Specify the input directory and output file
input_directory = '/panfs/jay/groups/26/mcgaughs/drabe004/BEARS/RELAX_results/'
output_file = 'Relax_results_summary.csv'

# Initialize an empty list to store the data
data = []

# Regular expression pattern to match "p = <number>"
p_value_pattern = re.compile(r'p\s*=\s*([\d.]+)')

# Iterate through each file in the input directory
for filename in os.listdir(input_directory):
    file_path = os.path.join(input_directory, filename)
    if os.path.isfile(file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()
            gene_name = filename.split('_')[0]
            p_value = None
            sentence = None

            # Iterate through the lines to find the p-value and sentence
            for line in lines:
                p_match = p_value_pattern.search(line)
                if p_match:
                    p_value = p_match.group(1)
                elif line.startswith(">"):
                    sentence = line.strip()

            # Append the data to the list
            if p_value is not None and sentence is not None:
                data.append([gene_name, p_value, sentence])

# Write the data to the output CSV file
with open(output_file, 'w') as outfile:
    outfile.write("Gene Name,P-Value,Sentence\n")
    for row in data:
        outfile.write(','.join(row) + '\n')

print(f"Data written to {output_file}")