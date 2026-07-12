#!/usr/bin/env bash
BOOKMARKS_DIRECTORY="$HOME/.local/share/config_dotfiles/bookmarks"
TAB_MODE="firefox --new-tab"; WINDOW_MODE="firefox --new-window"; PRIVATE_MODE="firefox --private-window"
if [[ ! -d "$BOOKMARKS_DIRECTORY" ]]; then
 notify-send -u critical "Create your bookmarks .txt files in $BOOKMARKS_DIRECTORY" 2>/dev/null; exit 1
fi
case "${1:-tab}" in
 tab) browser_command=$TAB_MODE ;;
 window) browser_command=$WINDOW_MODE ;;
 private) browser_command=$PRIVATE_MODE ;;
 *) notify-send "Invalid mode (tab|window|private)" 2>/dev/null; exit 1 ;;
esac
strip() { sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//;/^$/d' "$@"; }
if [[ "${2:-all}" == "all" ]]; then
 mapfile -t bookmarks < <(strip "$BOOKMARKS_DIRECTORY"/*.txt)
 [[ ${#bookmarks[@]} -gt 0 ]] || exit 0
 selected=$(printf '%s\n' "${bookmarks[@]}" | sort | wofi --dmenu -i --prompt "Bookmarks" --width 800)
else
 mapfile -t categories < <(find "$BOOKMARKS_DIRECTORY" -maxdepth 1 -type f -name "*.txt" -printf "%f\n")
 [[ ${#categories[@]} -gt 0 ]] || exit 0
 category=$(printf '%s\n' "${categories[@]}" | sort | wofi --dmenu -i --prompt "Categories" --width 400)
 [[ -n "$category" ]] || exit 0
 mapfile -t bookmarks < <(strip "$BOOKMARKS_DIRECTORY/$category")
 [[ ${#bookmarks[@]} -gt 0 ]] || exit 0
 selected=$(printf '%s\n' "${bookmarks[@]}" | sort | wofi --dmenu -i --prompt "$category" --width 800)
fi
[[ -n "$selected" ]] || exit 0
setsid $browser_command "$selected" >/dev/null 2>&1 &
