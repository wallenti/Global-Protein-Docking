#!/bin/bash -l
#SBATCH -J clean_pdbs
#SBATCH -D '/path/to/your/pdb/files'
#SBATCH -o clean_pdbs_%A_%a.out
#SBATCH --array=1-100
#SBATCH --time=1:00:00

# Load Python module (adjust as needed)
module load python/2.7

# Path to the clean_pdb.py script
clean_pdb_script="/path/to/rosetta/tools/protein_tools/scripts/clean_pdb.py"

# Chain identifier (e.g., ABCDEF)
chain_identifier="ABCDEF"

# Locate the PDB file for the current array index
pdb_file=$(ls /path/to/your/pdb/files/*.pdb | sed -n ${SLURM_ARRAY_TASK_ID}p)

# Check if the file exists
if [ -f "$pdb_file" ]; then
    # Run the clean_pdb.py script
    python2.7 "$clean_pdb_script" "$pdb_file" "$chain_identifier"
fi

echo "Finished cleaning PDB files."
