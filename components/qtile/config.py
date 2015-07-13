from socket import gethostname
from os.path import expanduser
from subprocess import Popen
from logging import getLogger
import enum
logger = getLogger('qtile')

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import libqtile.widget.base


HOSTNAME = gethostname()
BAR_HEIGHT = 25


mod = "mod4"


class BatteryWidget(libqtile.widget.base.ThreadedPollText):
    defaults = [
        ('update_interval', 5., 'Update interval for the clock'),
    ]

    def __init__(self, **config):
        libqtile.widget.base.ThreadedPollText.__init__(self, **config)
        self.add_defaults(BatteryWidget.defaults)

    def _read_file(self, path):
        return open(path).read()

    def refresh(self):
        status_str = self._read_file('/sys/class/power_supply/BAT0/status')
        self.bat_status = BatteryWidget.Status.parse(status_str)

        self.bat_curr = int(self._read_file('/sys/class/power_supply/BAT0/charge_now'))
        self.bat_full = int(self._read_file('/sys/class/power_supply/BAT0/charge_full'))

        self.ac_powered = bool(int(self._read_file('/sys/class/power_supply/ADP1/online')))
        self.power_curr = int(self._read_file('/sys/class/power_supply/BAT0/current_now'))


    def _get_percent(self):
        return float(self.bat_curr) / self.bat_full

    def _get_left_time(self):
        time = 0
        if self.bat_status is BatteryWidget.Status.CHARGING:
            try:
                time = (self.bat_full - self.bat_curr) / self.power_curr
            except ZeroDivisionError:
                time = -1
        elif self.bat_status is BatteryWidget.Status.DISCHARGING:
            try:
                time = self.bat_curr / self.power_curr
            except ZeroDivisionError:
                time = -1

        hour = 0
        minute = 0
        if time >= 0:
            hour = int(time)
            minute = int(time * 60) % 60
        else:
            hour = -1
            minute = -1
        return hour, minute


    def _get_text(self):
        status = {
            BatteryWidget.Status.FULL: "F",
            BatteryWidget.Status.CHARGING: "^",
            BatteryWidget.Status.DISCHARGING: "V",
            BatteryWidget.Status.UNKNOWN: "?",
        }.get(self.bat_status)
        hour, minute = self._get_left_time()

        return "{ac}{status} {percent:2.0%} {hour:02d}:{minute:02d}".format(
            ac="=" if self.ac_powered else "|",
            status=status,
            percent=self._get_percent(),
            hour=hour,
            minute=minute,
        )

    def poll(self):
        try:
            self.refresh()
            text = self._get_text()
        except Exception as e:
            logger.error(str(e))
            text = "XXX"
        return text


    class Status(enum.Enum):
        FULL = 0
        CHARGING = 1
        DISCHARGING = 2
        UNKNOWN = 3

        @classmethod
        def parse(cls, status_str):
            return {
                    'Full': cls.FULL,
                    'Charging': cls.CHARGING,
                    'Discharging': cls.DISCHARGING,
                    'Unknown': cls.UNKNOWN
            }.get(status_str.strip(), cls.UNKNOWN)


def get_screen_order():
    DEFAULT = [2, 0, 1]
    return {
        'stern': DEFAULT,
        'saya': DEFAULT,
    }.get(HOSTNAME, DEFAULT)

screen_order = get_screen_order()


@lazy.function
def reset_default_group(qtile):
    def get_group_by_name(name):
        for group in qtile.groups:
            if group.name == name:
                return group
        return None

    qtile.screens[0].setGroup(get_group_by_name('1'))
    qtile.screens[1].setGroup(get_group_by_name('-'))
    qtile.screens[2].setGroup(get_group_by_name('2'))


def move_window_to_the_screen(idx):
    @lazy.function
    def func(qtile):
        qtile.currentWindow.togroup(qtile.screens[screen_order[idx]].group.name)
    return func


keys = [
    # terminal
    Key([mod], "Return", lazy.spawn("mlterm")),

    # move focus
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "l", lazy.layout.right()),

    # focus screen
    Key([mod], "p", lazy.to_screen(screen_order[0])),
    Key([mod], "bracketleft", lazy.to_screen(screen_order[1])),
    Key([mod], "bracketright", lazy.to_screen(screen_order[2])),

    Key([mod, "shift"], "p", move_window_to_the_screen(0)),
    Key([mod, "shift"], "bracketleft", move_window_to_the_screen(1)),
    Key([mod, "shift"], "bracketright", move_window_to_the_screen(2)),

    # reset groups
    Key([mod], "r", reset_default_group),

    # launcher
    Key([mod], "d", lazy.spawn("xboomx")),
    Key([mod, "shift"], "l",
        lazy.spawn("xscreensaver-command --lock")),
    Key([mod], "w",
        lazy.spawn("python {home}/bin/WallpaperChanger/wallpaperchanger.py".format(home=expanduser("~")))),
    Key([mod, "shift"], "w",
        lazy.spawn("feh --bg-fill {home}/picture/wallpaper/saya.jpg".format(home=expanduser("~")))),

    # backlight
    Key([mod], "b", lazy.spawn("xbacklight =0")),
    Key([mod, "shift"], "b", lazy.spawn("xbacklight +5")),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.swap_left()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout()),
    # window close
    Key([mod, "shift"], "q", lazy.window.kill()),
    # disable floating
    Key([mod], "t", lazy.window.toggle_floating()),

    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod], "e", lazy.hide_show_bar()),
    Key([mod, "shift"], "Escape", lazy.shutdown()),
]

groups = [Group(name) for name in "1234567890-="]

for g in groups:
    key_name = {
        '-': 'minus',
        '=': 'equal',
    }.get(g.name, g.name)

    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], key_name, lazy.group[g.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], key_name, lazy.window.togroup(g.name))
    )


layouts = [
    layout.MonadTall(border_focus="#0000ff", border_width=1),
    layout.Max(),
    layout.TreeTab(),
]

def gen_bar():
    return bar.Bar(
        [
            widget.CPUGraph(),
            widget.NetGraph(),
            widget.GroupBox(inactive='606060', highlight_method='block', other_screen_border='214458'),
            widget.Prompt(),
            widget.WindowName(),
            widget.CurrentLayout(),
            widget.Sep(padding=5, linewidth=0),
            widget.Systray(),
        ] + ([
            BatteryWidget(),
        ]if HOSTNAME == 'saya'else [])+[
            widget.Sep(padding=5, linewidth=0),
            widget.Clock(format='%Y-%m-%d %a %H:%M:%S'),
            #widget.DebugInfo(),
        ],
        BAR_HEIGHT,
    )

def get_screens():
    DEFAULT = [
        Screen(top=gen_bar()),
        Screen(),
        Screen(),
    ]

    STERN = [
        Screen(),
        Screen(top=gen_bar()),
        Screen(),
    ]

    return {
        'stern': STERN,
        'saya': DEFAULT,
    }.get(HOSTNAME, DEFAULT)

@hook.subscribe.client_new
def floating_dialogs(window):
    is_dialog = window.window.get_wm_type() == 'dialog'
    is_transient = window.window.get_wm_transient_for()
    is_mikutter_preview = window.window.get_wm_window_role() == "mikutter_image_preview"
    if window.group is None:
        g_name = window.qtile.currentScreen.group.name
        window.togroup(g_name)
    if is_dialog or is_transient:
        window.floating = True

screens = get_screens()

widget_defaults = dict(
    font='Koruri',
    fontsize=16,
    padding=0,
)

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
