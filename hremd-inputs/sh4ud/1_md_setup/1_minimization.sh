#!/bin/bash
####################################################
####script below assumes gromacs is compiled########
####################################################


####If one is new to gromacs and encounters errors/problems, refer to an excellent tutorial by Justin Lemkul (http://www.mdtutorials.com/gmx/).

####Make a topology file using structure and force field for simulation. Make sure to have a structure file of a protein (e.g., histatin5.pdb) and a force field directory if one is using a different force field other than the available in the compiled version of the gromacs. pdb2gmx asks to choose a force field and water model. In this example, it will choose the force field and water model listed in option 1. Check and make sure.
gmx pdb2gmx -f sh4ud.pdb -o processed.gro <<EOF
1
1
EOF

####Prepare a simulaton box. For IDP, box dimension need to be large enough to prevent any periodic image interaction.
gmx editconf -f processed.gro -o newbox.gro -c -d 2.0 -bt cubic

####Make sure to have water structure file (e.g., tip4p2005.gro) in the working directory.
####Solvating a simulation box.
gmx solvate -cp newbox.gro -cs tip4p2005.gro -o solv.gro -p topol.top

####Adding counter ions to neutralize the box. Replace "SOL" while adding ions.
gmx grompp -f mdp/ions.mdp -c solv.gro -p topol.top -o ions.tpr -maxwarn 1
echo 13 | gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral

####Energy minimization.
gmx grompp -f mdp/mini.mdp -c solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -cpi -append -cpt 2 -s em.tpr -deffnm em
