#!/bin/bash
nsteps=1150
npar=115
let npar1=npar-1
let reps=nsteps/npar
let reps1=reps-1

export name=green
export npar=$npar
export nnodes=`echo $npar/2+1 | bc`
export ncores=`echo $nnodes*24 | bc`
export pov_ini=/scratch3/scratchdirs/loring/dipole3-den-isos-povray/den-isos-${name}.ini
export out_dir=/scratch3/scratchdirs/loring/dipole3-den-isos-povray/${name}-f095-orbit2
if [[ "${name}" == "green" ]]
then
  walltime="02:00:00"
else
  walltime="03:00:00"
fi

echo "name=$name"
echo "npar=$npar"
echo "nnodes=$nnodes"
echo "ncores=$ncores"
echo "pov_ini=$pov_ini"
echo "out_dir=$out_dir"
echo "walltime=${walltime}"

for i in `seq 3 $reps1`
do
  export base_step=`echo ${i}*${npar} | bc`
  jid=`qsub -v npar,nnodes,ncores,base_step,out_dir,pov_ini -N povray-deniso-${name} -A mpccc -q premium -l walltime=${walltime} -l mppwidth=${ncores} single-driver.qsub`
  echo "${i} jid=${jid} np=${npar} base_step=${base_step}"
done
