import os
import re
import sys
from collections import Counter

def remove_subspecies(organism_name):
    # Remove the subspecies by taking the first two names
    names = organism_name.split('_')
    if len(names) > 2:
        return '_'.join(names[:2])
    return organism_name

def modify_file(input_file, output_dir, log_file):
    output_file = os.path.join(output_dir, os.path.basename(input_file).replace('.aln', '.fasta'))
    modified_lines = []
    skip_sequence = False
    seen_organism_names = set()

    with open(input_file, 'r') as file:
        lines = file.readlines()

    for line in lines:
        if re.match(r'^>.*$', line):
            organism_match = re.search(r'\[organism=(.*?)\]', line)
            if organism_match:
                organism_name = organism_match.group(1).replace(' ', '_')
                if organism_name in ["Bos_indicus_x_Bos_taurus", "Canis_lupus_dingo"]:
                    skip_sequence = True
                else:
                    modified_organism_name = remove_subspecies(organism_name)
                    if modified_organism_name in seen_organism_names:
                        log_file.write(f"Duplicate name found: {modified_organism_name}\n")
                    seen_organism_names.add(modified_organism_name)
                    modified_line = f'>{modified_organism_name}\n'
                    modified_lines.append(modified_line)
                    skip_sequence = False
        else:
            if not skip_sequence:
                modified_lines.append(line)

    with open(output_file, 'w') as file:
        file.writelines(modified_lines)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 script.py dir/to/input/files dir/to/output/files")
        sys.exit(1)

    input_dir = sys.argv[1]
    output_dir = sys.argv[2]  # Replace 'output_directory' with the desired output directory path
    log_file_path = 'aln_dup_log.txt'

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(log_file_path, 'w') as log_file:
        for filename in os.listdir(input_dir):
            if filename.endswith('.aln'):
                input_file = os.path.join(input_dir, filename)
                modify_file(input_file, output_dir, log_file)
