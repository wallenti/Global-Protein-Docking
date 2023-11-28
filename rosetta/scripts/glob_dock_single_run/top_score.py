import os
import pandas as pd

# Directory containing the files
directory = '/u/jawall/2_rosetta/output/docking_unrelaxed_DD'

# List to store results
results = []

# Iterate over files in the directory
for filename in os.listdir(directory):
    if filename.startswith('docked') and filename.endswith('.pdb'):  # Adjust the pattern accordingly
        with open(os.path.join(directory, filename), 'r') as file:
            content = file.read()
            # Extract I_sc score
            isc_score = float(content.split('I_sc ')[1].split('\n')[0])
            results.append({'Filename': filename, 'I_sc': isc_score})

# Create a Pandas DataFrame
df = pd.DataFrame(results)

# Sort DataFrame by I_sc in descending order
df = df.sort_values(by='I_sc', ascending=True)

# Print the top 10 results
print(df.head(10))
