#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""colonize -- colonize a remote host w/ preferred bash settings.
"""

from paver.easy import sh, path

PATH = path(__file__).abspath().dirname().dirname() / '.colonize'

files = PATH.listdir()


def main(*targets):
    for t in targets:
        sh('ssh %s "mkdir -p .ssh"' % (t,))
        for f in files:
            sh('scp -r %s %s:' % (f, t))


if __name__ == "__main__":
    import sys
    main(*sys.argv[1:])
