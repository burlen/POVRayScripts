#/usr/bin/env python
from mpi4py import MPI as mpi
import os
import sys
rank = mpi.COMM_WORLD.Get_rank()
nproc = mpi.COMM_WORLD.Get_size()

pov_prefix='/usr/common/graphics/povray/3.7.1/bin/'

base_step = sys.argv[1]
pov_ini = sys.argv[2]
pov_config = sys.argv[3]
out_dir = sys.argv[4]

i = rank + int(base_step)
nt = 48

cmd = '%s/povray %s[%s] -V -GA +WT%d +K%d +O%s/den-%04d.png'%(pov_prefix,pov_ini,pov_config,nt,i,out_dir,i)

sys.stderr.write('=====%d %s\n'%(rank,cmd))
os.system(cmd)
sys.stderr.write('=====%d complete!\n'%(rank))
