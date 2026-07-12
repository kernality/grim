#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"

src="$DIR/../../config_dotfiles"
dest="$HOME/.local/share/config_dotfiles"
stage="${dest}.new"
old="${dest}.old"

previous_err_trap="$(trap -p ERR || true)"
previous_int_trap="$(trap -p INT || true)"
previous_term_trap="$(trap -p TERM || true)"

restore_traps() {
  trap - ERR INT TERM
  [[ -n "$previous_err_trap" ]] && eval "$previous_err_trap"
  [[ -n "$previous_int_trap" ]] && eval "$previous_int_trap"
  [[ -n "$previous_term_trap" ]] && eval "$previous_term_trap"
}

rollback() {
  rm -rf -- "$stage"
  if [[ ! -e "$dest" && -e "$old" ]]; then
    mv -- "$old" "$dest"
  fi
  restore_traps
}

trap rollback ERR INT TERM

[[ -d "$src" ]] || die "Missing source directory: $src"
mkdir -p -- "$(dirname "$dest")"
rm -rf -- "$stage" "$old"
cp -a -- "$src" "$stage"

executable_dirs=("$stage/config/custom_scripts")
[[ -d "$stage/config/waybar/scripts" ]] &&
  executable_dirs+=("$stage/config/waybar/scripts")

for executable_dir in "${executable_dirs[@]}"; do
  [[ -d "$executable_dir" ]] || continue
  find "$executable_dir" -type f -name '*.sh' -exec chmod 0755 {} +
done

[[ -f "$stage/config/lf/previewer" ]] &&
  chmod 0755 "$stage/config/lf/previewer"

# Unified Waybar layout: create the default stylesheet link when necessary.
if [[ -d "$stage/config/waybar/themes" &&
      ! -e "$stage/config/waybar/style.css" &&
      ! -L "$stage/config/waybar/style.css" ]]; then
  ln -s 'themes/waybar_underline/style.css' \
    "$stage/config/waybar/style.css"
fi

[[ -e "$dest" ]] && mv -- "$dest" "$old"
mv -- "$stage" "$dest"
rm -rf -- "$old"

restore_traps
success "Dotfiles deployed atomically"
