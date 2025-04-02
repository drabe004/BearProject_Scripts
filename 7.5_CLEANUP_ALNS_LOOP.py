import sys
import os
from Bio import AlignIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
from Bio.Align import MultipleSeqAlignment
import logging


def replace_stop_codons_with_gaps(alignment):
    stop_codons = {"TAA", "TAG", "TGA"}
    new_records = []
    max_length = alignment.get_alignment_length()

    for record in alignment:
        sequence = str(record.seq)
        new_seq = ""
        for i in range(0, len(sequence), 3):  # Processing sequence in triplets
            codon = sequence[i:i+3]
            if codon in stop_codons:
                break  # Stop processing this sequence further, a stop codon is encountered
            else:
                new_seq += codon  # Add the codon to the new sequence
        new_seq += '-' * (max_length - len(new_seq))  # Pad sequence with gaps if it's shorter than the longest sequence
        new_record = SeqRecord(Seq(new_seq), id=record.id, description=record.description)
        new_records.append(new_record)

    return MultipleSeqAlignment(new_records)


def trim_alignment_to_threshold(alignment, initial_threshold, secondary_threshold):
    sequence_length = alignment.get_alignment_length()
    codon_length = 3
    for threshold in [initial_threshold, secondary_threshold]:
        for i in range(0, sequence_length, codon_length):
            codon_column = alignment[:, i:i+codon_length]
            codon_presence = sum(1 for seq in codon_column if "-" not in seq) / len(alignment)
            if codon_presence >= threshold:
                return alignment[:, i:]
    logging.info(f"No columns met the {secondary_threshold*100:.0f}% presence requirement. Proceeding with the original alignment for {alignment[0].id}.")
    return alignment


def remove_species_with_high_gap_percentage(alignment, threshold):
    total_length = alignment.get_alignment_length()
    new_records = []

    for record in alignment:
        sequence = str(record.seq)
        gap_percentage = sequence.count('-') / total_length
        if gap_percentage <= threshold:
            new_records.append(record)

    return MultipleSeqAlignment(new_records)


if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: python script.py input_directory output_directory gap_threshold initial_threshold secondary_threshold debug_logfile")
        sys.exit(1)

    input_directory = sys.argv[1]
    output_directory = sys.argv[2]
    gap_threshold = float(sys.argv[3])
    initial_threshold = float(sys.argv[4])
    secondary_threshold = float(sys.argv[5])
    debug_logfile = sys.argv[6]

    logging.basicConfig(filename=debug_logfile, level=logging.INFO)

    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    for filename in os.listdir(input_directory):
        if filename.endswith(".fasta"):
            input_file_path = os.path.join(input_directory, filename)
            output_file_path = os.path.join(output_directory, filename.replace(".fasta", "_Dclean.fasta"))

            alignment = AlignIO.read(input_file_path, "fasta")
            alignment_with_gaps = replace_stop_codons_with_gaps(alignment)
            trimmed_alignment = trim_alignment_to_threshold(alignment_with_gaps, initial_threshold, secondary_threshold)

            final_alignment = remove_species_with_high_gap_percentage(trimmed_alignment, gap_threshold)

            with open(output_file_path, "w") as output_handle:
                AlignIO.write(final_alignment, output_handle, "fasta")

    print("Alignment processing complete.")
