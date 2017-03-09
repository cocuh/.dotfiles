# vim: fileencoding=utf-8

import readline
import rlcompleter
import atexit
import os

readline.parse_and_bind('tab: complete')
readline.set_history_length(1000)

histfile = os.path.expanduser('~/.python_history')

try:
    readline.read_history_file(histfile)
except IOError:
    pass

atexit.register(readline.write_history_file,histfile)
del os, histfile, readline, atexit, rlcompleter
