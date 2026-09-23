#!/usr/bin/env python3
# ~/.config/hypr/scripts/palette.py
"""Command palette and keybinding help for Hyprland (Super+Shift+P).

The palette doubles as keybinding help, so SECTIONS lists every binding in
hyprland.lua, runnable or not.

Adding an entry:
  - Append an Entry to the matching section in SECTIONS, or add a section.
  - label:   shown and searched in rofi.
  - keys:    binding shown next to the label; omit if unbound.
  - command: shell command run on selection (bash); omit for help-only rows.
  - Hyprland dispatchers run as Lua through hyprctl; use hypr("hl.dsp...").
  - Bindings that call local Lua functions in hyprland.lua (e.g. roles.*)
    cannot be reached from hyprctl; list them as help-only rows.
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


def hypr(expr: str) -> str:
    return f"hyprctl dispatch {shlex.quote(expr)}"


SECTIONS: dict[str, list[Entry]] = {
    "Hyprland": [
        # Reload fires config.reloaded, which reassigns monitors.
        Entry("Reload config and reassign monitors", command="hyprctl reload"),
        Entry("Hide scratchpad", "Super+Q", "~/.config/hypr/scripts/scratchpad-hide.sh"),
        Entry("Toggle floating", "Super+Shift+Space", hypr('hl.dsp.window.float({ action = "toggle" })')),
        Entry(
            "Toggle maximize",
            "Super+M",
            hypr('hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'),
        ),
        Entry("Close window", "Super+Shift+Q", hypr("hl.dsp.window.close()")),
        Entry("Lock screen", "Super+Shift+L", "loginctl lock-session"),
    ],
    "Screenshot": [
        Entry("Screenshot region and edit", "Print", 'grim -g "$(slurp)" - | swappy -f -'),
        Entry("Screenshot region to clipboard", command='grim -g "$(slurp)" - | wl-copy'),
        Entry("Screenshot full screen and edit", command="grim - | swappy -f -"),
        Entry(
            "Screenshot active window and edit",
            command=r"""grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -""",
        ),
    ],
    "Notifications": [
        Entry("Close notification", "Super+.", "dunstctl close"),
        Entry("Close all notifications", command="dunstctl close-all"),
        Entry("Show notification history", "Super+Shift+.", "dunstctl history-pop"),
        Entry("Toggle do not disturb", command="dunstctl set-paused toggle"),
    ],
    "Launchers": [
        Entry("Terminal", "Super+Return", "kitty"),
        Entry("Window list", "Super+D", "rofi -show window"),
        Entry("Application launcher", "Super+Shift+D", "rofi -show combi"),
        Entry("Command palette", "Super+Shift+P"),
    ],
    "Focus": [
        Entry("Focus left / down / up / right", "Super+H / J / K / L"),
        Entry("Focus monitor left / right", "Super+[ / ]"),
        Entry("Previous workspace", "Super+Tab", hypr('hl.dsp.focus({ workspace = "previous" })')),
        Entry("Scroll workspaces", "Super+Wheel"),
    ],
    "Workspaces": [
        Entry("Go to workspace 1-9", "Super+1..9"),
        Entry("Move window to workspace 1-9", "Super+Shift+1..9"),
        Entry("Go to sub monitor workspace", "Super+`"),
        Entry("Move window to sub monitor workspace", "Super+Shift+`"),
    ],
    "Scratchpads": [
        Entry("Toggle scratchpad 0 / - / = / W / E / R", "Super+0 / - / = / W / E / R"),
        Entry("Move window to scratchpad", "Super+Shift+0 / - / = / W / E / R"),
    ],
    "Mouse": [
        Entry("Move window", "Super+Left drag"),
        Entry("Resize window", "Super+Right drag"),
    ],
    "Session": [
        Entry(
            "Exit Hyprland",
            "Super+Shift+Escape",
            "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || " + hypr("hl.dsp.exit()"),
        ),
    ],
}


def render(entry: Entry) -> str:
    row = html.escape(entry.label)
    if entry.keys:
        row += f'  <span alpha="50%">{html.escape(entry.keys)}</span>'
    return row


def main() -> None:
    entries = [entry for section in SECTIONS.values() for entry in section]
    # dmenu mode rather than script mode, so rofi has closed before the
    # command runs and stays out of screenshots.
    result = subprocess.run(
        ["rofi", "-dmenu", "-i", "-markup-rows", "-format", "i", "-p", "palette"],
        input="\n".join(render(entry) for entry in entries),
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return

    command = entries[int(result.stdout)].command
    if command:
        subprocess.Popen(
            ["bash", "-c", command],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )


if __name__ == "__main__":
    sys.exit(main())
