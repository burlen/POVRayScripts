#/usr/bin/env python
from mpi4py import MPI as mpi
import os
import sys
rank = mpi.COMM_WORLD.Get_rank()
nproc = mpi.COMM_WORLD.Get_size()
prefix='/usr/common/graphics/povray/3.7.0/bin/'
ini='/scratch1/scratchdirs/loring/Pb7Bi4Se13/pbbise-edison.ini'
k=rank+37
i=rank
nt=24
cmd = '%s/povray %s -V -GA +WT%d +K%d +Opbbise-case-%d.png'%(prefix,ini,nt,k,k)
sys.stderr.write('=====%d %s\n'%(rank,cmd))
os.system(cmd)
sys.stderr.write('=====%d complete!\n'%(rank))
