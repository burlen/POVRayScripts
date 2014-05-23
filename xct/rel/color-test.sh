#!/bin/bash

declare -a colors=(\
"SpanishCrimson" \
"WebViolet" \
"BakerPink" \
"AmaranthPink" \
"UltraRed" \
"Cerise" \
"FrenchRaspberry" \
"BrilliantRose" \
"BeanRed" \
"CarnationPink" \
"LightCoral" \
"MyCyan" \
"SpanishSkyBlue" \
"ElectricBlue" \
"FreshAir" \
"Diamond" \
"Cyan" \
"Celeste" \
"Blizzard" \
"BeauBlue" \
"AirSuperiorityBlue" \
"WaterSpout" \
"Turquoise" \
"PowderBlue"
"PictonBlue" \
"Rackley" \
"Pastel" \
"PaleAqua"
)

i=0
for color in "${colors[@]}"
do
    f=${color}Iso.png;
    povray scene.ini +O$f +k$i
    #display $f &
    scp $f hpcvisco@hpcvis.com:www/vis/images/xct-atom-colors/
    let i=i+1
done
