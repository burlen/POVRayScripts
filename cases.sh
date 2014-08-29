#!/bin/bash

for i in `seq 41 0.125 44`
do
  j=`echo $i*1000 | bc`
  n=`printf %04.f $j`
  echo $i
  echo $j
  echo $n
  povray pbbise.ini +K$i +Opbbise-dep-case-$n.png
done
