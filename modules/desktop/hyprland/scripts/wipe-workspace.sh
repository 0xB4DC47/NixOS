#!/usr/bin/env bash
# Get the current workspace ID
ACTIVE_WS=$(hyprctl activeworkspace -j | jq '.id')

# Get all windows, filter for the active workspace, and close them by address
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ACTIVE_WS) | .address" | xargs -I {} hyprctl dispatch closewindow address:{}
