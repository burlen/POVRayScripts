#!/bin/bash
for i in `seq 0.0 0.05 0.35`
do
  j=`echo $i*1000 | bc`
  n=`printf %04.f $j`
  echo $n
  povray pbbise-dresden.ini +K$i +Opbbise-cpsi0-$n.png
done
