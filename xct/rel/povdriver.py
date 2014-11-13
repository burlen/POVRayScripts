#/usr/bin/env python
from mpi4py import MPI as mpi
import os
import sys
rank = mpi.COMM_WORLD.Get_rank()
nproc = mpi.COMM_WORLD.Get_size()
prefix='/usr/common/graphics/povray/3.7.0/bin/'
ini='scene.ini'
k=float(rank)/float(nproc)
i=rank
nt=24
cmd_l = '%s/povray %s[stereo_l] -V -GA +WT%d +K%0.6f +Oinn-rel-%04d-l.png'%(prefix,ini,nt,k,i)
sys.stderr.write('=====%d %s\n'%(rank,cmd_l))
os.system(cmd_l)
cmd_r = '%s/povray %s[stereo_r] -V -GA +WT%d +K%0.6f +Oinn-rel-%04d-r.png'%(prefix,ini,nt,k,i)
sys.stderr.write('=====%d %s\n'%(rank,cmd_r))
os.system(cmd_r)
sys.stderr.write('=====%d complete!\n'%(rank))
