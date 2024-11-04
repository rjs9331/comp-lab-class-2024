#!/bin/bash
#SBATCH --job-name=equilibration_system
#SBATCH --output=equilibration_system.out
#SBATCH --error=equilibration_system.err
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00


# Load required modules
module load lammps/openmpi/intel/20231214   # Load LAMMPS module

# Step 1: Create the system
echo "Creating the system..."
mpirun lmp -var configfile ../Inputs/n360/kalj_n360_create.lmp -var id 1 -in ../Inputs/create_3d_binary.lmp

# Step 2: Equilibrate at progressively lower temperatures
# Define the temperature list
temperatures=(1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475)

# Loop through the temperatures
for temp in "${temperatures[@]}"; do
    echo "Equilibrating at T = $temp"
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T${temp}.lmp -var id 1 -in ../Inputs/anneal_3d_binary.lmp
done

echo "All equilibration steps completed."
