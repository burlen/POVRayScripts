#!/bin/bash
for i in `seq 0.1 0.1 0.6`
do
  j=`echo $i*1000 | bc`
  n=`printf %04.f $j`
  echo $n
  povray pbbise-dresden.ini +K$i +Opbbise-fb-case-$n.png
done
povray pbbise-dresden-lg.ini +K0.45 +Opbbise-fb-case-$n.png
