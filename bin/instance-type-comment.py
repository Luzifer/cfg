#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright:
#   2017 Knut Ahlers <github.com/Luzifer>
# License:
#   Apache v2.0
#   https://www.apache.org/licenses/LICENSE-2.0.html

from __future__ import print_function

# included
import json
import os
import sys
import time

# external requirement
import requests

SOURCE_FILE = 'https://ec2instances.info/instances.json'
CACHE_TIME = 7 * 24 * 3600
CACHE_FILE = os.path.expanduser('~/.local/share/itc/instances.json')
REGION_FALLBACK = 'eu-west-1'


def beautify_ecu(ecu):
    if ecu == 'variable':
        return 'var'
    return str(ecu).strip('.0')


def beautify_mem(mem):
    return str(mem).strip('.0')


def get_region():
    if 'AWS_REGION' in os.environ:
        return os.environ['AWS_REGION']
    if 'AWS_DEFAULT_REGION' in os.environ:
        return os.environ['AWS_DEFAULT_REGION']
    return REGION_FALLBACK


def monthly_pricing(hourly_rate):
    price = float(hourly_rate) * 24 * 365 / 12
    return round(price)


def renew_cache():
    least_mod_time = time.time() - CACHE_TIME
    if os.path.isfile(CACHE_FILE) and os.path.getmtime(CACHE_FILE) > least_mod_time:
        return

    try:
        os.makedirs(os.path.dirname(CACHE_FILE))
    except OSError:
        # Creating an existing directory will fail which is okay
        pass

    with open(CACHE_FILE, 'w') as cf:
        cf.write(requests.get(SOURCE_FILE).text)

    return


def generate_comment(instance_type):
    renew_cache()
    region = get_region()

    instances = json.loads(open(CACHE_FILE, 'r').read())
    for instance in instances:
        if instance['instance_type'] != instance_type:
            continue

        if region not in instance['pricing']:
            print('Region "{}" is unknown in pricing table.'.format(region))
            return None

        return '{vcpu} ({ecu}) / {mem} / {network} / ${price:.0f}'.format(
            vcpu=instance['vCPU'],
            ecu=beautify_ecu(instance['ECU']),
            mem=beautify_mem(instance['memory']),
            network=instance['network_performance'],
            price=monthly_pricing(
                instance['pricing'][region]['linux']['ondemand']),
        )


def main(args):
    comment = generate_comment(args[1])
    if comment is None:
        return 1

    print('      InstanceTypeComment: {}'.format(comment))
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(
            'Please supply an instance type to format: e.g. {} m4.large'.format(sys.argv[0]))
        sys.exit(1)
    sys.exit(main(sys.argv))
