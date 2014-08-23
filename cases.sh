#!/bin/bash

for i in `seq 11 36`
do
  povray pbbise.ini +K$i +Opbbise-case-$i.png
done
