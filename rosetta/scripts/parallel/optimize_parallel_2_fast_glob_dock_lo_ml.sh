#!/bin/bash -l

# Slurm Directives
#SBATCH -J docking_relax
#SBATCH -D '/path/to/rosetta/output/subfolder_1'
#SBATCH -o job_%A_%a.out
#SBATCH --nodes=2
#SBATCH --ntasks=72
#SBATCH --constraint=gpu
#SBATCH --gres=gpu:a100:4
#SBATCH --array=1-100
#SBATCH --mail-type=NONE
#SBATCH --mail-user=your@email.com
#SBATCH --time=23:00:00

# Load Rosetta environment (adjust paths accordingly)
# source /u/jawall/rosetta/main/source/tools/protein_tools/init.sh

cd /path/to/rosetta/scripts/parallel

# Locate the PDB file for the current array index
pdb=$(ls /path/to/rosetta//path/to/rosetta/input/subfolder_1_relaxed/*.pdb | sed -n ${SLURM_ARRAY_TASK_ID}p)

# Check if the file exists
if [ -f "$pdb" ]; then
    # Create a subdirectory for each array index
    output_subdirectory="/path/to/rosetta/output/subfolder_1/docked_$SLURM_ARRAY_TASK_ID"
    mkdir -p "$output_subdirectory"

    # Run docking protocol 100 times
    for ((i=1; i<=100; i++)); do
        /path/to/rosetta/main/source/bin/docking_protocol.mpi.linuxgccrelease @parallel_glob.flags -s "$pdb" -out:prefix "$output_subdirectory/docked_${SLURM_ARRAY_TASK_ID}_run$i" &
    done
else
    echo "Error: PDB file not found for task ID $SLURM_ARRAY_TASK_ID."
fi

# Wait for all background jobs to finish
wait

echo "Finished docking for all PDBs."
