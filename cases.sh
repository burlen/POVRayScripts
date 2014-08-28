#!/bin/bash

for i in `seq 0 1 20`
do
  let j=-10+$i
  n=`printf %04.f $i`
  povray pbbise.ini +K$j +Opbbise-li-case-$n.png
done
