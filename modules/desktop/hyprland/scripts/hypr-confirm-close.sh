#!/usr/bin/env bash
# prompt "Close window?" with Yes/No via wofi
choice=$(printf "Yes\nNo" \
  | wofi --dmenu --prompt="Close window?" --lines=5)
[ "$choice" = "Yes" ] && ./dontkillsteam.sh #hyprctl dispatch killactive
