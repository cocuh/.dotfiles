#!/bin/python
import sys
import os

import argparse
import logging

if sys.version_info[0] == 3:
    import configparser
else:
    import ConfigParser as configparser

logging.basicConfig(level=logging.INFO)

FILEPATH = os.path.abspath(sys.argv[0])
PATH = os.path.dirname(FILEPATH)

CONF_PATH = os.path.join(PATH, 'install.conf')
PLUGIN_PATH = os.path.join(PATH, 'plugins')


def check_files(target_paths):
    flag = True
    for from_path, to_path in target_paths:
        if not os.path.exists(from_path):
            logging.error('No such file: {0}'.format(from_path))
            flag = False
        if os.path.exists(to_path):
            if not os.path.islink(to_path):
                logging.error('The file exists(not symbolic link): {0}'.format(from_path))
                flag = False
    return flag


def install(target_paths, is_debug=False):
    for from_path, to_path in target_paths:
        logging.info('installing {f} to {t}'.format(
            f=from_path,
            t=to_path,
        ))
        if not is_debug:
            if os.path.islink(to_path):
                os.remove(to_path)
            os.symlink(from_path, to_path)


def get_plugin_names(conf, profile_name):
    return [
        plugin
        for plugin in
        conf.get('PROFILES', profile_name).splitlines()
        if plugin
    ]


def parse_args(conf):
    profile_names = conf.options('PROFILES')
    plugin_names = sorted(set(conf.sections()) - set('PROFILES'))

    parser = argparse.ArgumentParser()
    parser.add_argument('profile', choices=profile_names)
    parser.add_argument('plugins', nargs='*', choices=[[]] + plugin_names)
    parser.add_argument('--debug', action='store_true')
    return parser.parse_args()


def main():
    conf = configparser.ConfigParser()
    conf.read(CONF_PATH)

    args = parse_args(conf)
    plugins = get_plugin_names(conf, args.profile) + args.plugins

    target_paths = []
    for plugin in plugins:
        target_paths += conf.items(plugin)
    target_paths = [
        (
            paths[0].format(**{
                'plugin': PLUGIN_PATH,
            }),
            os.path.expanduser(paths[1])
        )
        for paths in
        target_paths
    ]

    if check_files(target_paths):
        install(target_paths, is_debug=args.debug)
    else:
        raise BaseException()


if __name__ == '__main__':
    main()
