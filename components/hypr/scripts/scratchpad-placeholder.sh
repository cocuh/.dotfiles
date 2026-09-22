#!/usr/bin/env bash
# ~/.config/hypr/scripts/scratchpad-placeholder.sh
set -euo pipefail

name="${1:-unknown}"

kitty \
  --class "scratchpad-empty-placeholder" \
  --title "Scratchpad ${name} is empty" \
  --override background_opacity=0.65 \
  --override background="#3a3a3a" \
  --override foreground="#dddddd" \
  sh -c "sleep 0.5"