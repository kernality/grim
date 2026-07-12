#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"

directories=(
  "$HOME/.local/share"
  "$HOME/.local/share/applications"
  "$HOME/.config"
  "$HOME/.config.backup"
  "$HOME/Pictures/screenshots"
  "$HOME/Pictures/backgrounds"
)

for directory in "${directories[@]}"; do
  mkdir -p -- "$directory"
  info "Directory ready: $directory"
done

success "Required user directories created"
