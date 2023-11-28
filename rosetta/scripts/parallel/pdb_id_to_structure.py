import requests
import os
import pandas as pd

# Path to the CSV file containing PDB IDs
csv_file_path = '/path/to/rosetta/input/pdb_id.csv'

# Output directory to save the downloaded PDB files
output_directory = '/path/to/rosetta/input/input_pdbs'

# Ensure the output directory exists
os.makedirs(output_directory, exist_ok=True)

# Read PDB IDs from CSV file
pdb_ids = pd.read_csv(csv_file_path, header=None)[0]

# Download PDB files for each PDB ID
for pdb_id in pdb_ids:
    pdb_url = f'https://files.rcsb.org/download/{pdb_id}.pdb'
    output_path = os.path.join(output_directory, f'{pdb_id}.pdb')

    try:
        response = requests.get(pdb_url)
        if response.status_code == 200:
            with open(output_path, 'wb') as pdb_file:
                pdb_file.write(response.content)
            print(f'Downloaded {pdb_id}.pdb to {output_path}')
        else:
            print(f'Failed to download {pdb_id}.pdb. Status code: {response.status_code}')
    except Exception as e:
        print(f'Error downloading {pdb_id}.pdb: {str(e)}')

print('Download complete.')
