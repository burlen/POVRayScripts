#/usr/bin/env python
from mpi4py import MPI as mpi
import os
import sys
rank = mpi.COMM_WORLD.Get_rank()
nproc = mpi.COMM_WORLD.Get_size()
prefix='/usr/common/graphics/povray/3.7.0/bin/' #'/work/apps/povray/bin/'
ini='/scratch1/scratchdirs/loring/pov-pr/scene.ini' #'/work2/xct/data/crystal/pov-pr/scene.ini'
k=float(rank)/float(nproc)
i=rank
nt=24
cmd = '%s/povray %s -V -GA +WT%d +K%0.6f +Oinn-%04d.png'%(prefix,ini,nt,k,i)
sys.stderr.write('=====%d %s\n'%(rank,cmd))
os.system(cmd)
sys.stderr.write('=====%d complete!\n'%(rank))
