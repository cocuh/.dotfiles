#!/usr/bin/env bash
# ~/.config/hypr/scripts/scratchpad-hide.sh
set -euo pipefail

name="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .specialWorkspace.name | sub("^special:"; "")')"

if [ -n "$name" ]; then
  hyprctl dispatch "hl.dsp.workspace.toggle_special(\"${name}\")"
fi
