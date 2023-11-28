#!/bin/bash

# Input directory for PDB files
input_directory="/ptmp/jawall/2_rosetta_input/MYD88_MS_pdb/organized_pdbs/subfolder_1_relaxed/1-100_pdbs"

# Output directory for processed PDB files
output_directory="/ptmp/jawall/2_rosetta_input/af_MYD88_MS_pdb/subfolder_1_merge"


# Fixed PDB file
fixed_pdb_file="/u/jawall/pymol/af_MYD88_1WH4_IRAK4DD/head_merge_iso_relaxed_af/new_relaxed_15MYDDOSOME_TERNARY_DD_COMPLEX_model_4_multimer_v3_p2_231025_247375_0001_D.pdb"

# Create output directory if it doesn't exist
mkdir -p "$output_directory"

# Iterate over all PDB files in the input directory
for pdb_file in "$input_directory"/*.pdb; do
    # Check if it's a file
    if [ -f "$pdb_file" ]; then
        # Extract the PDB name without the extension
        pdb_name=$(basename -- "$pdb_file")
        pdb_name="${pdb_name%.*}"

        # Run pymol command
        pymol -cQ -d "load $pdb_file, MY; load $fixed_pdb_file, IR; create MYD88_MS, (MY) or (IR); save $output_directory/${pdb_name}_MYD88.pdb, MYD88_MS"
    fi
done

echo "Processing complete."
