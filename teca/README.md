for i in `seq 0 1000`; do ii=`printf %04.f $i`; echo i=$i; povray +k$i +O/work2/teca/tc_1990s_cori/2880_x_1620/povray/cam5_hero_180_$ii.png cam5_hero.ini; done
