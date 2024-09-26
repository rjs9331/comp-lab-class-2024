#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=15:00:00
#SBATCH --mem=2GB
#SBATCH --job-name=hellompi
#SBATCH --output=hellompi.out

# Load the default OpenMPI module.
module purge
module load gromacs/openmpi/intel/2020.4
# Run the hellompi program with mpirun. The -n flag is not required;
# mpirun will automatically figure out the best configuration from the
# Slurm environment variables.
gmx_mpi mdrun -deffnm md_0_1
