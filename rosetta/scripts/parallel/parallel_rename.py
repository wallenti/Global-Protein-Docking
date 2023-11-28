import os

def process_pdbs(input_folder, output_folder):
    # Create the output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    # List all PDB files in the input folder
    pdb_files = [file for file in os.listdir(input_folder) if file.endswith('.pdb')]

    for pdb_file in pdb_files:
        # Load the PDB file in PyMOL
        cmd.load(os.path.join(input_folder, pdb_file))

        # Alter all chains to "G"
        cmd.alter('all', 'chain="G"')

        # Save the modified PDB file
        output_file = os.path.join(output_folder, f'new_{pdb_file}')
        cmd.save(output_file)

        # Delete the loaded structure
        cmd.delete('all')

    print(f'Processed {len(pdb_files)} PDB files.')

# Specify the input and output folders
input_folder = '/path/to/rosetta/input/input_pdbs/organized_pdbs/subfolder_1'
output_folder = '/path/to/rosetta/input/input_pdbs/organized_pdbs/subfolder_1_rename'

# Call the function to process the PDB files
process_pdbs(input_folder, output_folder)
