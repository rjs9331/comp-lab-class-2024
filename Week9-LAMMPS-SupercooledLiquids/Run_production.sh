#!/bin/bash
#SBATCH --job-name=production_simulation
#SBATCH --output=production_simulation.out
#SBATCH --error=production_simulation.err
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00  # Adjusted for 3 times shorter duration

# Set OpenMP threads
export OMP_NUM_THREADS=1

# Load required modules
module load lammps/openmpi/intel/20231214

# Step 2: Run production simulations at progressively lower temperatures
temperatures=(1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475)

# Loop through the temperatures
for temp in "${temperatures[@]}"; do
    echo "Running production simulation at T = $temp"
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T${temp}.lmp -var id 1 -in ../Inputs/production_3d_binary.lmp
done

echo "All production simulations completed."