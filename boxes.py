import random
import sys

print "#declare Boxes = union {"

colors = [
#'P_Brass1',
#'P_Brass2',
#'P_Brass3',
#'P_Brass4',
#'P_Brass5',
#'P_Copper1',
#'P_Copper2',
#'P_Copper3',
#'P_Copper4',
#'P_Copper5',
#'Gray70',
#'Gray75',
#'Gray80',
#'Gray85',
#'Gray90',
#'Gray95',
'White*0.90',
'White*0.91',
'White*0.92',
'White*0.93',
'White*0.94',
'White*0.95',
'White*0.96',
'White*0.97',
'White*0.98',
'White*0.99',
'White*1.00',
#'P_Chrome1',
#'P_Chrome2',
#'P_Chrome3',
#'P_Chrome4',
#'P_Chrome5',
#'P_Silver1',
#'P_Silver2',
#'P_Silver3',
#'P_Silver4',
#'P_Silver5'
]


class Box:
    def __init__(self, x0,y0,z0, x1,y1,z1):
        self.x0 = x0
        self.y0 = y0
        self.z0 = z0
        self.x1 = x1
        self.y1 = y1
        self.z1 = z1

    def In(self, x,y,z):
        return (((x>=self.x0) and (x<=self.x1)) and ((z>=self.z0) and (z<=self.z1)))

def In(boxes, x,y,z):
    for b in boxes:
        if b.In(x,y,z):
            return True
    return False

def Covered(boxes, box):
    return (In(boxes, box.x0,box.y0,box.z0) and
        In(boxes, box.x1, box.y0, box.z0) and
        In(boxes, box.x1, box.y0, box.z1) and
        In(boxes, box.x0, box.y0, box.z1) and
        In(boxes, (box.x0+box.x1)/2.0, y0, (box.z0+box.z1)/2.0))


def output(s):
    sys.stdout.write('%s\n'%(str(s)))

def outputTex(color, finish):
    output('texture { pigment { %s } finish { %s } }'%(color, finish))

def outputPt(x,y,z):
    output('<%0.4f, %0.4f, %0.4f>'%(x, y, z))

def outputVal(v):
    output('%0.4f'%(v))

def outputBox(x0,y0,z0, x1,y1,z1, color, finish):
    output('box {')
    outputPt(x0,y0,z0)
    outputPt(x1,y1,z1)
    outputTex(color, finish)
    output('}')

def outputCyl(x0,y0,z0, x1,y1,z1, r, color, finish):
    output('cylinder {')
    outputPt(x0,y0,z0)
    outputPt(x1,y1,z1)
    output(r)
    outputTex(color,finish)
    output('}')

ncolors = 10
xw = 10.0
yw = 5.0
zw = 100.0

cr = yw/40.0

xp = 100.0
yp = 5.0
zp = 100.0

boxes = []

i=0
while i<100:
    xs = max(1.0, random.random()*xw)
    #ys = max(0.125, random.random()*yw)
    ys = 0.0625
    zs = max(10.0, random.random()*zw)

    dx = -xp/2.0 + random.random()*xp
    dy = -yp/2.0 + random.random()*yp
    dz = -zp/2.0 + random.random()*zp

    x0 = dx
    x1 = dx + xs
    y0 = dy
    y1 = dy + ys
    z0 = dz
    z1 = dz + zs

    box = Box(x0,y0,z0, x1,y1,z1)

    if not Covered(boxes, box):

        boxes.append(box)

        outputBox(x0,y0,z0, x1,y1,z1, 'BoxColor%d'%(random.randint(1,ncolors)), 'BoxFinish')

        output('#if (RenderBoxEdges)')
        outputCyl(x0,y0,z0, x1,y0,z0, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x1,y0,z0, x1,y0,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x0,y0,z0, x0,y0,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x0,y0,z1, x1,y0,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')

        outputCyl(x0,y0,z0, x0,y1,z0, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x1,y0,z0, x1,y1,z0, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x1,y0,z1, x1,y1,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x0,y0,z1, x0,y1,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')

        outputCyl(x0,y1,z0, x1,y1,z0, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x0,y1,z0, x0,y1,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x1,y1,z0, x1,y1,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')
        outputCyl(x0,y1,z1, x1,y1,z1, 'BoxEdgeWidth', 'BoxEdgeColor', 'BoxEdgeFinish')

        output('#end')


    i += 1

print "}"
