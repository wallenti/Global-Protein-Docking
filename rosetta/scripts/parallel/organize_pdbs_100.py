import os
import shutil

def organize_pdbs(directory):
    # Create a new directory to store subfolders
    output_directory = os.path.join(directory, 'organized_pdbs')
    os.makedirs(output_directory, exist_ok=True)

    # List all PDB files in the input directory
    pdb_files = [file for file in os.listdir(directory) if file.endswith('.pdb')]

    # Organize PDBs into subfolders
    subfolder_count = 1
    current_subfolder = os.path.join(output_directory, f'subfolder_{subfolder_count}')
    os.makedirs(current_subfolder, exist_ok=True)

    for i, pdb_file in enumerate(pdb_files, start=1):
        # Move the current PDB file to the subfolder
        shutil.move(os.path.join(directory, pdb_file), current_subfolder)

        # Create a new subfolder if the current one reaches 100 files
        if i % 100 == 0:
            subfolder_count += 1
            current_subfolder = os.path.join(output_directory, f'subfolder_{subfolder_count}')
            os.makedirs(current_subfolder, exist_ok=True)

    print(f'Organized {len(pdb_files)} PDB files into subfolders.')

# Specify the directory containing the PDB files
pdb_directory = '/path/to/rosetta/input/input_pdbs'

# Call the function to organize the PDB files
organize_pdbs(pdb_directory)
