#!/usr/bin/env python

import json, sys, urllib

data = json.loads(open(sys.argv[1], 'r').read())

keys = sorted(data.keys())
last = data[keys[0]]
distsum = 0

for key in keys[1:]:
  start = '%s,%s' % tuple(last)
  end = '%s,%s' % tuple(data[key])
  url = 'http://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&sensor=false' % (start, end)
  result = json.loads(urllib.urlopen(url).read())
  dist = result['routes'][0]['legs'][0]['distance']['value']
  distsum = distsum + dist
  last = data[key]
  
print 'Distance of list: %.2f km' % (float(distsum) / 1000.0)
