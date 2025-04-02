import os
from Bio import SeqIO
import argparse

def find_extra_headers(headers1, headers2):
    extra_headers1 = set(headers1) - set(headers2)
    extra_headers2 = set(headers2) - set(headers1)
    return extra_headers1, extra_headers2

def main(input_directory, output_directory):
    # Ensure the output directory exists or create it
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    # Get a list of unique file prefixes
    file_prefixes = set(filename.split('_')[0] for filename in os.listdir(input_directory))

    for prefix in file_prefixes:
        protein_file = os.path.join(input_directory, f"{prefix}_prot.fasta")
        transcript_file = os.path.join(input_directory, f"{prefix}_refseq_transcript_RENAMED.fasta")

        # Check if both files exist for the pair
        if os.path.exists(protein_file) and os.path.exists(transcript_file):
            # Read headers from both files
            protein_headers = [str(seq.id) for seq in SeqIO.parse(protein_file, "fasta")]
            transcript_headers = [str(seq.id) for seq in SeqIO.parse(transcript_file, "fasta")]

            # Find extra headers in each file
            extra_headers_protein, extra_headers_transcript = find_extra_headers(protein_headers, transcript_headers)

            # Filter sequences to keep
            filtered_protein_sequences = [seq for seq in SeqIO.parse(protein_file, "fasta") if str(seq.id) not in extra_headers_protein]
            filtered_transcript_sequences = [seq for seq in SeqIO.parse(transcript_file, "fasta") if str(seq.id) not in extra_headers_transcript]

            # Write the updated sequences to new fasta files
            output_protein_file = os.path.join(output_directory, f"{prefix}_prot.fasta")
            output_transcript_file = os.path.join(output_directory, f"{prefix}_refseq_transcript_RENAMED.fasta")

            with open(output_protein_file, "w") as f1, open(output_transcript_file, "w") as f2:
                SeqIO.write(filtered_protein_sequences, f1, "fasta")
                SeqIO.write(filtered_transcript_sequences, f2, "fasta")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check and update paired fasta files.")
    parser.add_argument("input_directory", help="Path to the input directory containing paired fasta files.")
    parser.add_argument("output_directory", help="Path to the output directory for updated fasta files.")
    args = parser.parse_args()

    main(args.input_directory, args.output_directory)
