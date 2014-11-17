#/usr/bin/env python
from mpi4py import MPI as mpi
import os
import sys
rank = mpi.COMM_WORLD.Get_rank()
nproc = mpi.COMM_WORLD.Get_size()

prefix='/usr/common/graphics/povray/3.7.1/bin/'
ini='/scratch3/scratchdirs/loring/dipole3-den-isos-povray/den-isos.ini'

i=rank
nt=24

cmd = '%s/povray %s -V -GA +WT%d +K%d +Oden-%04d.png'%(prefix,ini,nt,i,i)

sys.stderr.write('=====%d %s\n'%(rank,cmd))
os.system(cmd)
sys.stderr.write('=====%d complete!\n'%(rank))
