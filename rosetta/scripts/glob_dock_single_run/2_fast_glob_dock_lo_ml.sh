#!/bin/bash -l

# Slurm Directives
#SBATCH -J 1_node_2_gpu
#SBATCH -D '/u/jawall/2_rosetta/output/af_MYD88_1WH4_IRAK4'
#SBATCH -o job_%A_%a.out
#SBATCH --nodes=2
#SBATCH --ntasks=72
#SBATCH --constraint=gpu
#SBATCH --gres=gpu:a100:4
#SBATCH --array=1-100
#SBATCH --mail-type=NONE
#SBATCH --mail-user=wallentin@mpiib-berlin.mpg.de
#SBATCH --time=23:00:00

# Load Rosetta environment (adjust paths accordingly)
# source /u/jawall/rosetta/main/source/tools/protein_tools/init.sh

cd /u/jawall/2_rosetta/scripts

# Create a folder for each array index
for i in $(seq $SLURM_ARRAY_TASK_MIN $SLURM_ARRAY_TASK_MAX); do
    mkdir -p "/u/jawall/2_rosetta/output/af_MYD88_1WH4_IRAK4/docked_$i"
done

# Run docking protocol for each array index
for i in $(seq $SLURM_ARRAY_TASK_MIN $SLURM_ARRAY_TASK_MAX); do
    /u/jawall/2_rosetta/main/source/bin/docking_protocol.mpi.linuxgccrelease @glob.flags -out:prefix "/u/jawall/2_rosetta/output/af_MYD88_1WH4_IRAK4/docked_$i/docked_$i" &
done

# Wait for all background jobs to finish
wait

echo "finished docking relaxed"
