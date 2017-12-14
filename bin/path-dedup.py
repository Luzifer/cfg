#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import os

out = []
[out.append(i) for i in os.environ["PATH"].split(":") if not out.count(i)]
print(":".join(out))
