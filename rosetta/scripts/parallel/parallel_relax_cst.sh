#!/bin/bash -l
#SBATCH -J relax_pdbs
#SBATCH -D '/path/to/rosetta/output/subfolder_1_relaxed'
#SBATCH -o relax_pdbs_%A_%a.out
#SBATCH --array=1-100
#SBATCH --ntasks=72
#SBATCH --constraint=gpu
#SBATCH --gres=gpu:a100:4
#SBATCH --mail-type=NONE
#SBATCH --mail-user=your@email.com
#SBATCH --time=23:00:00

# Load Rosetta environment (adjust paths accordingly)
#source /u/jawall/rosetta/main/source/tools/protein_tools/init.sh

cd /u/jawall/2_rosetta/scripts

# Define the path to the Rosetta Scripts executable
rosetta_scripts="/path/to/rosetta/main/source/bin/rosetta_scripts.mpi.linuxgccrelease"

# Define the protocol file for relaxation (e.g., relax_cst.xml)
protocol_file="/path/to/rosetta/scripts/parallel/relax_cst.xml"

# Define the output directory
output_directory="/path/to/rosetta/output/subfolder_1_relaxed"

# Locate the PDB file for the current array index
pdb_file=$(ls /ptmp/jawall/2_rosetta_input/MYD88_MS_pdb/organized_pdbs/subfolder_1_rename/*.pdb | sed -n ${SLURM_ARRAY_TASK_ID}p)

# Check if the file exists
if [ -f "$pdb_file" ]; then
# Create a subdirectory for each array index
    mkdir -p "$output_directory/relaxed_${SLURM_ARRAY_TASK_ID}"

    # Run Rosetta Scripts for relaxation
    $rosetta_scripts -parser:protocol $protocol_file -s "$pdb_file" -parser:protocol relax_cst.xml -out:prefix "$output_directory/relaxed_${SLURM_ARRAY_TASK_ID}" &
fi

wait

echo "Finished relaxing PDB files."
