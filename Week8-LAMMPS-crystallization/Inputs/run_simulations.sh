#!/bin/bash

# Create directories for saving results
mkdir -p Trajectories Data

# Loop over densities from 0.5 to 1.1 in increments of 0.1
for density in $(seq 0.5 0.1 1.1)
do
    # Copy the original input file to a temporary file for modification
    cp in.melt in.melt.tmp
    
    # Update the input file for the current density
    sed -i "s/DENSITY_PLACEHOLDER/$density/g" in.melt.tmp
    
    # Run the simulation and save the log file using output redirection
    mpirun lmp -in in.melt.tmp > "Data/log_${density}.log" 2>&1

    # Move the trajectory file if it exists
    if [[ -f dump.melt ]]; then
        cp dump.melt "Trajectories/dump_${density}.melt"
    else
        echo "Warning: dump.melt not found for density: $density"
    fi
    
    echo "Simulation completed for density: $density"
done
