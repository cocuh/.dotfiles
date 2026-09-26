#!/usr/bin/env python3
# ~/.config/hypr/scripts/palette.py
"""Command palette and keybinding help for Hyprland (Super+Shift+P).

The palette doubles as keybinding help, so SECTIONS lists every binding in
hyprland.lua, runnable or not.

Adding an entry:
  - Append an Entry to the matching Section in SECTIONS, or add a Section.
  - Section icon: a freedesktop icon name from the installed icon theme;
    the section name is searchable but not shown.
  - label:   shown and searched in rofi.
  - keys:    binding shown next to the label; omit if unbound.
  - command: shell command run on selection (bash); omit for help-only rows.
  - Hyprland dispatchers run as Lua through hyprctl; use hypr_dispatch("hl.dsp...").
  - Local Lua functions in hyprland.lua cannot be reached from hyprctl;
    call module functions with hypr_eval('require("module").fn()') instead.
  - When changing a binding in hyprland.lua, update its keys here.

Only SECTIONS needs editing for new entries; the code below it renders them.
"""

import html
import shlex
import subprocess
import sys
from dataclasses import dataclass


@dataclass(frozen=True)
class Entry:
    label: str
    keys: str = ""
    command: str | None = None


@dataclass(frozen=True)
class Section:
    name: str
    icon: str
    entries: list[Entry]


def hypr_dispatch(expr: str) -> str:
    return f"hyprctl dispatch {shlex.quote(expr)}"


def hypr_eval(code: str) -> str:
    return f"hyprctl eval {shlex.quote(code)}"


SECTIONS: list[Section] = [
    Section("Hyprland", "preferences-system", [
        Entry("Reload config", command="hyprctl reload"),
        Entry("Hide scratchpad", "Super+Q", "~/.config/hypr/scripts/scratchpad-hide.sh"),
        Entry("Toggle floating", "Super+Shift+Space", hypr_dispatch('hl.dsp.window.float({ action = "toggle" })')),
        Entry(
            "Toggle maximize",
            "Super+M",
            hypr_dispatch('hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'),
        ),
        Entry("Close window", "Super+Shift+Q", hypr_dispatch("hl.dsp.window.close()")),
        Entry("Lock screen", "Super+Alt+L", "loginctl lock-session"),
        Entry("Toggle waybar", "Super+B", "pkill waybar || waybar"),
    ]),
    Section("Screenshot", "camera-photo", [
        Entry("Screenshot region and edit", "Print", 'grim -g "$(slurp)" - | swappy -f -'),
        Entry("Screenshot region to clipboard", command='grim -g "$(slurp)" - | wl-copy'),
        Entry("Screenshot full screen and edit", command="grim - | swappy -f -"),
        Entry(
            "Screenshot active window and edit",
            command=r"""grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -""",
        ),
    ]),
    Section("Notifications", "preferences-system-notifications", [
        Entry("Close notification", "Super+.", "dunstctl close"),
        Entry("Close all notifications", command="dunstctl close-all"),
        Entry("Show notification history", "Super+Shift+.", "dunstctl history-pop"),
        Entry("Toggle do not disturb", command="dunstctl set-paused toggle"),
    ]),
    Section("Launchers", "system-run", [
        Entry("Terminal", "Super+Return", "kitty"),
        Entry("Window list", "Super+D", "rofi -show window"),
        Entry("Application launcher", "Super+Shift+D", "rofi -show combi"),
        Entry("Command palette", "Super+Shift+P"),
    ]),
    Section("Focus", "view-grid", [
        Entry("Focus left / down / up / right", "Super+H / J / K / L"),
        Entry("Focus monitor left / right", "Super+[ / ]"),
        Entry("Previous workspace", "Super+Tab", hypr_dispatch('hl.dsp.focus({ workspace = "previous" })')),
        Entry("Scroll workspaces", "Super+Wheel"),
    ]),
    Section("Workspaces", "workspace-switcher", [
        Entry("Go to workspace 1-9", "Super+1..9"),
        Entry("Move window to workspace 1-9", "Super+Shift+1..9"),
        Entry("Go to sub monitor (cycles through several)", "Super+`"),
        Entry("Move window to the first sub monitor", "Super+Shift+`"),
        Entry("Make focused monitor main", command=hypr_eval('require("monitor_roles").set_main_to_focused()')),
    ]),
    Section("Scratchpads", "window-new", [
        Entry("Toggle scratchpad 0 / - / = / W / E / R", "Super+0 / - / = / W / E / R"),
        Entry("Move window to scratchpad", "Super+Shift+0 / - / = / W / E / R"),
    ]),
    Section("Mouse", "input-mouse", [
        Entry("Move window", "Super+Left drag"),
        Entry("Resize window", "Super+Right drag"),
    ]),
    Section("Session", "system-log-out", [
        Entry(
            "Exit Hyprland",
            "Super+Shift+Escape",
            "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || " + hypr_dispatch("hl.dsp.exit()"),
        ),
    ]),
]


def render(section: Section, entry: Entry) -> str:
    row = html.escape(entry.label)
    if entry.keys:
        row += f'  <span alpha="50%">{html.escape(entry.keys)}</span>'
    return f"{row}\0icon\x1f{section.icon}\x1fmeta\x1f{section.name}"


def main() -> None:
    rows = [(section, entry) for section in SECTIONS for entry in section.entries]
    # dmenu mode rather than script mode, so rofi has closed before the
    # command runs and stays out of screenshots.
    result = subprocess.run(
        ["rofi", "-dmenu", "-i", "-markup-rows", "-show-icons", "-format", "i", "-p", "palette"],
        input="\n".join(render(section, entry) for section, entry in rows),
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return

    _, entry = rows[int(result.stdout)]
    if entry.command:
        subprocess.Popen(
            ["bash", "-c", entry.command],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )


if __name__ == "__main__":
    sys.exit(main())
