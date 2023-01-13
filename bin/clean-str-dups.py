#!/usr/bin/env python

import os
import sys


def main(args):
    sep = args[1]
    in_str = args[2]
    out = []

    [
        out.append(i)
        for i in in_str.split(sep)
        if not out.count(i)
    ]

    print(sep.join(out))

    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
