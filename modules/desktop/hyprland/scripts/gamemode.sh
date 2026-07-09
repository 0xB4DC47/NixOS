#!/usr/bin/env bash
# HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '2p' | awk '{print $2}')
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

if [ $HYPRGAMEMODE = 1 ]; then
  hyprctl -q --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:blur:xray 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword decoration:active_opacity 1 ;\
        keyword decoration:inactive_opacity 1 ;\
        keyword decoration:fullscreen_opacity 1 ;\
        keyword layerrule no_anim true, match:namespace waybar ;\
        keyword layerrule no_anim true, match:namespace swaync-notification-window ;\
        keyword layerrule no_anim true, match:namespace awww-daemon ;\
        keyword layerrule no_anim true, match:namespace rofi"
  hyprctl 'keyword windowrule opaque true, match:class (.*)' # ensure all windows are opaque
  exit
else
  hyprctl reload config-only -q
fi
