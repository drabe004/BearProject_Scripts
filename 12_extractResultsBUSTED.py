import os
import re
import csv
import argparse

def extract_p_value(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        last_line = lines[-1].strip()
        p_value_match = re.search(r'p\s*=\s*([\d.]+)', last_line)
        if p_value_match:
            p_value = p_value_match.group(1)
            return p_value
    return None

def main(input_directory, output_file):
    data = []

    for file_name in os.listdir(input_directory):
        if file_name.endswith("_BUSTED"):
            gene_name = file_name.split("_")[0]
            file_path = os.path.join(input_directory, file_name)
            p_value = extract_p_value(file_path)
            if p_value is not None:
                data.append((gene_name, p_value))

    with open(output_file, 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["GeneName", "P-Value"])
        csv_writer.writerows(data)

    print(f"Summary saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract p-values from BUSTED output files.")
    parser.add_argument("input_directory", help="Path to the directory containing BUSTED output files")
    parser.add_argument("-o", "--output_file", default="BUSTED_Summary.csv", help="Name of the output CSV file (default: BUSTED_Summary.csv)")

    args = parser.parse_args()
    main(args.input_directory, args.output_file)
