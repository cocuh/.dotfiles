#!/usr/bin/env python3
# coding: utf-8

from sys import argv
import dbus

class KeyboardBacklight:
    def __init__(self):
        bus = dbus.SystemBus()
        proxy = bus.get_object('org.freedesktop.UPower', '/org/freedesktop/UPower/KbdBacklight')
        interface = dbus.Interface(proxy, 'org.freedesktop.UPower.KbdBacklight')
        self.interface = interface
        self.maximum = interface.GetMaxBrightness()

    def get_value(self):
        current = self.interface.GetBrightness()
        return current

    def set_value(self, value):
        value = max(0, min(value, self.maximum))
        self.interface.SetBrightness(value)
        return value

    def increment(self):
        return self.set_value(self.get_value() + 1)

    def decrement(self):
        return self.set_value(self.get_value() - 1)


if __name__ == '__main__':
    backlight = KeyboardBacklight()

    if len(argv[1:]) == 1:
        if argv[1] == "--up" or argv[1] == "+":
            # ./kb-light.py (+|--up) to increment
            res = backlight.increment()
            print(res)
        elif argv[1] == "--down" or argv[1] == "-":
            # ./kb-light.py (-|--down) to decrement
            res = backlight.decrement()
            print(res)
        elif argv[1].isdigit():
            value = int(argv[1])
            res = backlight.set_value(value)
            print(res)
        else:
            print("Unknown argument:", argv[1])
    else:
        print("Script takes exactly one argument.", len(argv[1:]), "arguments provided.")
