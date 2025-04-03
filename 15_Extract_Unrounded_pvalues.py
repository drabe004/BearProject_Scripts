import os
import json
import csv
import sys

def extract_pvalues(directory):
    extracted_data = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('BUSTED.json'):
                prefix = file.split('_')[0]
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as json_file:
                    try:
                        data = json.load(json_file)
                        p_value = data.get("test results", {}).get("p-value")
                        if p_value is not None:
                            extracted_data.append([prefix, p_value])
                    except json.JSONDecodeError:
                        print(f"Could not decode JSON in file: {file_path}")
    return extracted_data

def write_csv(data, output_file):
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(data)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <directory_path> <output_file>")
        sys.exit(1)

    directory_path, output_file = sys.argv[1:3]
    
    extracted_data = extract_pvalues(directory_path)
    write_csv(extracted_data, output_file)
