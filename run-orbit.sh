#!/bin/bash

od=orbit-8

nsteps=1150
npar=23
let npar1=npar-1
let wid=nsteps/npar
let wid1=wid-1

for i in `seq 0 $wid`
do
  for j in `seq 0 $npar1`
  do
    let jj=i*npar+j
    n=`printf %04.f $jj`
    of=${od}/orbit-${n}.png
    if [ ! -f ${of} ]
    then
      povray den-isos.ini +K${jj} +O${of} &
      pid=$!
    else
      echo "skipped ${jj}"
    fi
  done
  wait $pid
done
