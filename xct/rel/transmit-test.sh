#!/bin/bash

for j in `seq 0 16`
do
    i=`printf %02.f $j`
    f=PictonBlueT${i}.png;
    povray scene.ini +O$f +k$j
    #display $f &
    scp $f hpcvisco@hpcvis.com:www/vis/images/xct-atom-colors/
done
