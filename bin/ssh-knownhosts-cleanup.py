#!/usr/bin/env python3
# encoding: utf-8
# By Joonas Kuorilehto 2011, MIT license
# https://gist.github.com/joneskoo/1306614
#
# The script combines .ssh/known_hosts so that each fingerprint is only
# listed once.

import re
import sys
import os
import shutil

HOME = os.environ['HOME']
KNOWN_HOSTS = os.path.join(HOME, '.ssh', 'known_hosts')

# Backup known hosts file
shutil.copyfile(KNOWN_HOSTS, KNOWN_HOSTS+".old")

# Read known hosts to memory
with open(KNOWN_HOSTS) as f:
    knownhosts = dict()
    oldlines = 0
    for line in f:
        if line.strip() == "" or line.strip().startswith("#"):
            continue
        oldlines += 1
        hosts, keytype, fingerprint = line.strip().split(" ")
        dictkey = keytype + fingerprint
        hosts = hosts.split(",")
        if knownhosts.get(dictkey) == None:
            knownhosts[dictkey] = dict(hosts=set(), keytype=keytype,
                                       fingerprint=fingerprint)
        knownhosts[dictkey]['hosts'].update(hosts)

lines = []
for key, host in knownhosts.items():
    host['hosts_joined'] = ",".join(sorted(host['hosts'], reverse=True))
    lines.append("%(hosts_joined)s %(keytype)s %(fingerprint)s" % host)

# Replace known hosts with a cleaned version
with open(KNOWN_HOSTS, 'w') as f:
    f.write("\n".join(sorted(lines)))
    f.write("\n")

print("OK. Cleaned up", KNOWN_HOSTS)
print("Change: from %d lines to %d lines." % (oldlines, len(knownhosts)))
