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

def gen_tensorflow_session(gpus=[], keras=True):
    import tensorflow as tf
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    if gpus:
        if not isinstance(gpus, list):
            gpus = [gpus]
        config.gpu_options.visible_device_list = ','.join(map(str, gpus))
    sess = tf.Session(config=config)

    if keras:
        try:
            import keras.backend as K
            K.set_section(sess)
        except:
            pass
    return sess
