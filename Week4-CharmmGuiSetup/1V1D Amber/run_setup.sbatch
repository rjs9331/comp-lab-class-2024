#!/bin/bash

#SBATCH --nodes=4
#SBATCH --ntasks-per-node=24
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mem=2GB
#SBATCH --job-name=hellocharmm
#SBATCH --output=hellocharmm.out

module purge
module load gromacs/openmpi/intel/2023.3

init=step3_input
mini_prefix=step4.0_minimization
equi_prefix=step4.1_equilibration
prod_prefix=step5_production
prod_step=step5

# Minimization
srun -n 1 gmx_mpi grompp -f ${mini_prefix}.mdp -o ${mini_prefix}.tpr -c ${init}.gro -r ${init}.gro -p topol.top -n index.ndx -maxwarn 2
srun -n 1 gmx_mpi mdrun -v -deffnm ${mini_prefix} 

# Equilibration
srun -n 1 gmx_mpi grompp -f ${equi_prefix}.mdp -o ${equi_prefix}.tpr -c ${mini_prefix}.gro -r ${init}.gro -p topol.top -n index.ndx -maxwarn 2
srun -n 1 gmx_mpi mdrun -v -deffnm ${equi_prefix}

# Production
cnt=1
cntmax=6

while [ ${cnt} -lt ${cntmax} ]
do
    pcnt=$((${cnt}-1))
    istep=${prod_step}_${cnt}
    pstep=${prod_step}_${pcnt}

    if [ ${cnt} -eq 1 ]; then
        pstep=${equi_prefix}
        srun -n 1 gmx_mpi grompp -f ${prod_prefix}.mdp -o ${istep}.tpr -c ${pstep}.gro -p topol.top -n index.ndx
    else
        srun -n 1 gmx_mpi grompp -f ${prod_prefix}.mdp -o ${istep}.tpr -c ${pstep}.gro -t ${pstep}.cpt -p topol.top -n index.ndx
    fi

    # Use all available tasks for production runs
    srun -n 96 gmx_mpi mdrun -v -deffnm ${istep}
    
    cnt=$(($cnt+1))
done
