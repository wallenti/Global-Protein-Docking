import os
import pandas as pd

# Directory containing the files
directory = '/u/jawall/2_rosetta/output/new_3MOP_crtl/all_files'

# List to store results
results = []

# Iterate over files in the directory
for filename in os.listdir(directory):
    if filename.startswith('dock') and filename.endswith('.pdb'):  # Adjust the pattern accordingly
        with open(os.path.join(directory, filename), 'r') as file:
            content = file.read()

            # Check if content contains 'I_sc ' before attempting to split
            if 'I_sc ' in content:
                isc_start_index = content.find('I_sc ')
                isc_end_index = content.find('\n', isc_start_index)

                # Check if both start and end indices are found
                if isc_start_index != -1 and isc_end_index != -1:
                    isc_score = float(content[isc_start_index + len('I_sc '):isc_end_index].strip())
                else:
                    isc_score = None
            else:
                isc_score = None

            # Extract st_rmsd score
            st_rmsd_start_index = content.find('st_rmsd ')
            st_rmsd_end_index = content.find('\n', st_rmsd_start_index)

            # Check if both start and end indices are found
            if st_rmsd_start_index != -1 and st_rmsd_end_index != -1:
                st_rmsd_score = float(content[st_rmsd_start_index + len('st_rmsd '):st_rmsd_end_index].strip())
            else:
                st_rmsd_score = None

            results.append({'Filename': filename, 'I_sc': isc_score, 'st_rmsd': st_rmsd_score})

# Create a Pandas DataFrame
df = pd.DataFrame(results)

# Save the DataFrame to a CSV file
output_csv_path = '/u/jawall/2_rosetta/output/new_3MOP_crtl/docking_table.csv'
df.to_csv(output_csv_path, index=False)
