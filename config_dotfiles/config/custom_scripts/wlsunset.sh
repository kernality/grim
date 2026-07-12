#!/usr/bin/env bash
set -Eeuo pipefail

latitude="${WLSUNSET_LAT:-22.5726}"
longitude="${WLSUNSET_LON:-88.3639}"

if pgrep -x wlsunset >/dev/null 2>&1; then
  pkill -x wlsunset
  notify-send "Night color" "Disabled"
else
  wlsunset \
    -l "$latitude" \
    -L "$longitude" \
    -t 4000 \
    -T 4001 \
    >/dev/null 2>&1 &
  notify-send "Night color" "Enabled"
fi
