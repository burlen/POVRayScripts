#!/bin/bash
nsteps=1550
npar=310
let npar1=npar-1
let reps=nsteps/npar
let reps1=reps-1

export name=green
export npar=$npar
procs_per_node=1
export nnodes=`echo $npar*$procs_per_node | bc`
export ncores=`echo $nnodes*24 | bc`
export pov_ini=/scratch3/scratchdirs/loring/dipole3-den-isos-povray/den-isos-${name}.ini
export pov_config=edison_1440
export out_dir=/scratch3/scratchdirs/loring/dipole3-den-isos-povray/${name}-f050-orbit2-1440
walltime="10:00:00"

echo "name=$name"
echo "npar=$npar"
echo "nnodes=$nnodes"
echo "ncores=$ncores"
echo "pov_ini=$pov_ini"
echo "pov_config=$pov_config"
echo "out_dir=$out_dir"
echo "walltime=${walltime}"

for i in `seq 2 $reps1`
do
  export base_step=`echo ${i}*${npar} | bc`
  #jid=`qsub -v npar,nnodes,ncores,base_step,out_dir,pov_ini,pov_config -N povray-deniso-${name} -A m1303 -q regular -l walltime=${walltime} -l mppwidth=${ncores} single-driver.qsub`
  echo "${i} jid=${jid} np=${npar} base_step=${base_step}"
done
