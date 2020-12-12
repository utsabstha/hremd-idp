#!/bin/bash
####################################################
####script below assumes gromacs is compiled####
####################################################

####If one is new to gromacs and encounters errors/problems, refer to an excellent tutorial by Justin Lemkul (http://www.mdtutorials.com/gmx/).

####NPT equilibration.
gmx grompp -f mdp/nvt.mdp -c nvt.gro -r nvt.gro -p topol.top -o npt.tpr
gmx mdrun -cpi -append -cpt 5 -s npt.tpr -deffnm npt

####Generate a gromacs tpr for production run.
gmx grompp -f mdp/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md.tpr

