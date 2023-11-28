#!/bin/bash

# Input directory for PDB files
input_directory="/path/to/input_structure.pdb"

# Output directory for processed PDB files
output_directory="/path/to/rosetta/input/docking_partner_A"

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
        pymol -cQ -d "load $pdb_file; select MYD88, chain A+B+C+D+E+F; save $output_directory/new_${pdb_name}.pdb, MYD88"
    fi
done

echo "Processing complete."
