import numpy as np
import matplotlib.pyplot as mpl
from mpl_toolkits.mplot3d import Axes3D
from math import *

def invox(t,r):
  return r*np.cos(t) + r*t*np.sin(t);

def invoy(t,r):
  return r*np.sin(t) - r*t*np.cos(t);

def archx(t, a, b, c):
  return c*(a + b*t)*np.cos(t);

def archy(t, a, b, c):
  return c*(a + b*t)*np.sin(t);

def cirx(t, r):
  return r*np.cos(t)

def ciry(t, r):
  return r*np.sin(t)


def rarch(t,a,b,c):
    return c*(a + b*t)

def xrtp(r,t,p):
    return r*np.sin(t)*np.cos(p)

def yrtp(r,t,p):
    return r*np.sin(t)*np.sin(p)

def zrtp(r,t,p):
    return r*np.cos(t)

def dx(t):
    return np.cos(t);

def dz(t):
    return -np.sin(t);

d = pi/100
t = np.arange(pi/2.0, 5.0*pi/2.0+d/2.0, d);
tt = np.arange(5*pi/2.0, 7.0*pi/2.0+d/2.0, d);
ttt = np.arange(7.0*pi/2.0, 9.0*pi/2.0+d/2.0, d);

print 'delta = %f'%(d)
print 'nsteps = %d'%(len(t))

i = np.arange(0,4);
t2 = (2.0*i+1.0)*pi/2.0;

a = -100.0
b = 600.0/pi

aa = -9900.0
bb = 3400.0/pi

r = rarch(t,a,b,1)
p = t*0.0

rr = rarch(tt,a,b,1)
pp = tt*0.0 #+ pi/4

rrr = 2000.0+ttt*0.0
ppp = ttt*0.0

mpl.plot(xrtp(-r,t,p), zrtp(-r,t,p), 'r-')
mpl.plot(xrtp(-rr,tt,pp), -zrtp(-rr,tt,pp),  'b-')
mpl.plot(xrtp(-rrr,ttt,ppp), zrtp(-rrr,ttt,ppp), 'r-')

mpl.axis('equal')
mpl.grid(True)
mpl.xlabel('X',fontweight='bold')
mpl.ylabel('Z',fontweight='bold')

q = np.array([pi/2.0, pi, 3.0*pi/2.0, 2.0*pi, 5.0*pi/2.0])
qq = np.array([3.0*pi, 7.0*pi/2.0])
qqq = np.array([4.0*pi, 9.0*pi/2])

mpl.quiver(xrtp(-rarch(q,a,b,1),q,q*0.0), zrtp(-rarch(q,a,b,1),q,q*0.0), dx(q), dz(q))
mpl.quiver(xrtp(-rarch(qq,a,b,1),qq,qq*0.0), -zrtp(-rarch(qq,a,b,1),qq,qq*0.0), -dx(qq), dz(qq))
mpl.quiver(xrtp(-2000.0+qqq*0.0,qqq,qqq*0.0), zrtp(-2000.0+qqq*0.0,qqq,qqq*0.0), dx(qqq), dz(qqq))

mpl.show()
