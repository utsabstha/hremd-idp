#!/bin/bash
#########################################################################
####script below assumes gromacs and plumed are compiled#################
#########################################################################

####Script below is adopted from PLUMED HREMD tutorial: https://www.plumed.org/doc-v2.5/user-doc/html/hrex.html#:~:text=When%20patching%20GROMACS%20with%20PLUMED,the%20-hrex%20flag%20of%20mdrun%20.

#number of replicas
nrep=16
# "effective" temperature range
tmin=293
tmax=400

# build geometric progression
list=$(
awk -v n=$nrep \
    -v tmin=$tmin \
    -v tmax=$tmax \
  'BEGIN{for(i=0;i<n;i++){
    t=tmin*exp(i*log(tmax/tmin)/(n-1));
    printf(t); if(i<n-1)printf(",");
  }
}'
)

# clean directory
rm -fr \#*
rm -fr topol*

for((i=0;i<nrep;i++))
do

# choose lambda as T[0]/T[i]
# remember that high temperature is equivalent to low lambda
  lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')
# process topology
 plumed partial_tempering $lambda < processed_.top > topol$i.top
# prepare tpr file
# -maxwarn is often needed because box could be charged
 gmx grompp -maxwarn 1 -o topol$i.tpr -f md.mdp -p topol$i.top -c md.tpr
done

