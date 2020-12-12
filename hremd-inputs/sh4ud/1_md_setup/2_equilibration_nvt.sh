#!/bin/bash
####################################################
####script below assumes gromacs is compiled####
####################################################

####If one is new to gromacs and encounters errors/problems, refer to an excellent tutorial by Justin Lemkul (http://www.mdtutorials.com/gmx/).

####NVT equilibration.
gmx grompp -f mdp/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -cpi -append -cpt 5 -s nvt.tpr -deffnm nvt
