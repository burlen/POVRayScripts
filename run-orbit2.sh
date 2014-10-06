#!/bin/bash

od=orbit-9

nsteps=1150
npar=16

start=0
fini=1450

for i in `seq $start $fini`
do
    n=`printf %04.f ${i}`
    of=${od}/orbit-${n}.png
    povray den-isos.ini +K${i} +O${of} &
    pid=$!
    q=`echo ${i}%${npar} | bc`
    if [ "${q}" -eq "0" ]
    then
        wait ${pid}
    fi
done
