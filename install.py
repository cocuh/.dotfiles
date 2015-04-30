#!/usr/bin/env python
import sys
import os

import logging

if sys.version_info[0] == 3:
    import configparser
else:
    import ConfigParser as configparser

logging.basicConfig(level=logging.INFO)

FILEPATH = os.path.abspath(sys.argv[0])
PATH = os.path.dirname(FILEPATH)

CONF_PATH = os.path.join(PATH, 'install.conf')
COMPONENT_PATH = os.path.join(PATH, 'components')


def check_files(target_paths):
    flag = True
    for from_path, to_path in target_paths:
        if not os.path.exists(from_path):
            logging.error('No such file: {0}'.format(from_path))
            flag = False
        if os.path.exists(to_path):
            if not os.path.islink(to_path):
                logging.error('The file exists(not symbolic link): {0}'.format(to_path))
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


def get_component_names(conf, profile_name):
    return [
        component
        for component in
        conf.get('PROFILES', profile_name).splitlines()
        if component
    ]


def parse_args(conf):
    profile_names = conf.options('PROFILES')
    component_names = sorted(set(conf.sections()) - set('PROFILES'))

    try:
        import argparse
        is_argparse = True
    except:
        is_argparse = False

    if is_argparse:
        parser = argparse.ArgumentParser()
        parser.add_argument('profile', choices=profile_names)
        parser.add_argument('components', nargs='*', choices=[[]] + component_names)
        parser.add_argument('--debug', action='store_true')
        return parser.parse_args()
    else:
        if len(sys.argv) < 2:
            print('\n'.join([
                    "Usage: {cmd} profile",
                    "    profiles: {profiles}"
                ]).format(cmd=sys.argv[0], profiles=', '.join(profile_names))
            )
        class Args:
            def __init__(self, profile):
                self.profile = profile
                self.components = []
                self.debug = False

        profile = sys.argv[1]
        if profile in profile_names:
            args = Args(profile)
        return args


def main():
    conf = configparser.ConfigParser()
    conf.read(CONF_PATH)

    args = parse_args(conf)
    components = get_component_names(conf, args.profile) + args.components

    target_paths = []
    for component in components:
        target_paths += conf.items(component)
    target_paths = [
        (
            paths[0].format(**{
                'path': COMPONENT_PATH,
            }),
            os.path.expanduser(paths[1])
        )
        for paths in
        target_paths
    ]

    if check_files(target_paths):
        install(target_paths, is_debug=args.debug)
        print("")
        print("install successed!!!")
        print("")
    else:
        raise BaseException()


if __name__ == '__main__':
    main()
