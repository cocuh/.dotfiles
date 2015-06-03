from socket import gethostname
from os.path import expanduser
from subprocess import Popen
from logging import getLogger
logger = getLogger('qtile')

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook


HOSTNAME = gethostname()
BAR_HEIGHT = 25


mod = "mod4"


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
            widget.Battery(low_percentage=0.15, update_delay=5, foreground='7070ff'),
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
