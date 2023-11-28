#!/bin/bash -l

# Slurm Directives (customize these based on your cluster's configuration)
#!/bin/bash -l
#
# Name of SLURM-job
#SBATCH -J relax_og
#
# Initial working directory:
#SBATCH -D 'path/to/rosetta/input'
# Standard output and error:
#SBATCH -o job_%A_%a.out        # Standard output, %A = job ID, %a = job array index
#
# Number of nodes and MPI tasks per node:
#SBATCH --ntasks=72
#SBATCH --constraint=gpu
#SBATCH --gres=gpu:a100:4
#
# Define the SLURM-array to analyse multiple pdb structures in parallel
#
#SBATCH --mail-type=NONE
#SBATCH --mail-user=wallentin@mpiib-berlin.mpg.de
#SBATCH --time=23:00:00


# Load Rosetta environment (adjust paths accordingly)
#source   /u/jawall/rosetta/main/source/tools/protein_tools/init.sh

cd /u/jawall/2_rosetta/scripts

/u/jawall/2_rosetta/main/source/bin/rosetta_scripts.mpi.linuxgccrelease -parser:protocol relax_cst.xml -s /path/to/input_structure.pdb -parser:protocol relax_cst.xml -out:prefix /path/to/rosetta/input/mut_

echo "finished mutate"
