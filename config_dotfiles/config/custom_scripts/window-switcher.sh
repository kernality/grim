#!/usr/bin/env bash
sel="$(swaymsg -t get_tree | jq -r '
 recurse(.nodes[]?, .floating_nodes[]?)
 | select(.type=="con" or .type=="floating_con")
 | select(.name != null and .name != "")
 | "\(.id)\t\(.app_id // .window_properties.class // "?")  \(.name)"' \
 | wofi --dmenu -i --prompt "windows" --width 720)"
[ -z "$sel" ] && exit 0
id="${sel%%$'\t'*}"
[ -n "$id" ] && swaymsg "[con_id=$id]" focus
