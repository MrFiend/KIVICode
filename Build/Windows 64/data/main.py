import math
from dxfwrite import DXFEngine as dxf
import os
import sys
print(sys.argv)
params = sys.argv[1].split(';')
len = len(params)-1
name = str(sys.argv[2])


drawing = dxf.drawing(name + '.dxf')

for x in range(0, len):
    cmd = params[x].split('(')[0]
    p = params[x].split('(')[1].split(')')[0].split(',')
    if cmd == 'line':
        drawing.add(dxf.line((float(p[0]), float(p[1])), (float(p[2]), float(p[3]))))
    elif cmd == 'circle':
        circle = dxf.circle(float(p[0]), (float(p[1]), float(p[2])))
        drawing.add(circle)
    elif cmd == 'ellipse':
        circle = dxf.circle(float(p[0]), (float(p[1]), float(p[2])))
        drawing.add(circle)
    elif cmd == 'point':
        point = dxf.point((float(p[1]), float(p[2])))
        drawing.add(point)
    elif cmd == 'rect':

        drawing.add(dxf.line(
            (float(p[0]), float(p[1])),
            (float(p[0])+float(p[2]), float(p[1]))
        ))

        drawing.add(dxf.line(
            (float(p[0]) + float(p[2]), float(p[1])),
            (float(p[0])+float(p[2]), float(p[1])+float(p[3]))

        ))
        drawing.add(dxf.line(
            (float(p[0]) + float(p[2]), float(p[1]) + float(p[3])),
            (float(p[0]),float(p[1])+float(p[3]))
        ))

        drawing.add(dxf.line(
            (float(p[0]),float(p[1])+float(p[3])),
            (float(p[0]), float(p[1]))
        ))
    elif cmd == "arcIn":
        x1 = float(p[0])
        y1 = float(p[1])
        x2 = float(p[2])
        y2 = float(p[3])
        centerX = float([2])
        centerY = float([3])
        rad = abs(centerX-x1) # x1,y1 x2,y2 centerX,centerY

        angleDeg = math.atan2(y2 - y1, x2 - x1) * 180 / math.pi;
        drawing.add(dxf.arc(rad,(centerX,centerY)))
drawing.save()
path = '\"'
for x in range(3, 4):
    path += sys.argv[x] + ' '
path = path[:-1] + '\"'
print('mv ~/'+name+'.dxf ' + path)
os.system('mv ~/'+name+'.dxf ' + path)