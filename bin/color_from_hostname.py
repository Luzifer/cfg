#!/usr/bin/env python

import socket

hostname = socket.gethostname()

s = 0
for c in hostname:
  s = s + ord(c)

color = str(1 + s % 14).rjust(3, '0')
print '$FG[{}]'.format(color)
