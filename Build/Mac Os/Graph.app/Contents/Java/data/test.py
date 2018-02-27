from dxfwrite import DXFEngine as dxf

drawing = dxf.drawing('drawing.dxf')
arc = dxf.arc(0.1, (1.0, 1.0), 0, 90)
arc['layer'] = 'points'
arc['color'] = 7
arc['center'] = (2, 3, 7) # int or float
arc['radius'] = 3.5
drawing.add(arc)
drawing.save()