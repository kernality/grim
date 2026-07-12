#!/usr/bin/env bash
SETUP_SHELL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SETUP_SHELL_PATH/mini_functions.sh"

info "Installing zsh + plugins + starship ..."
for pkg in zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions starship; do
 xbps-query "$pkg" &>/dev/null || sudo xbps-install -y "$pkg" || warning "Skipping $pkg"
done

zsh_path="$(command -v zsh)"
if [[ -n "$zsh_path" ]]; then
 grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
 current_shell="$(getent passwd "$USER" | cut -d: -f7)"
 [[ "$current_shell" != "$zsh_path" ]] && { info "Setting zsh as login shell ..."; sudo chsh -s "$zsh_path" "$USER"; }
else
 warning "zsh not found after install; leaving login shell unchanged."
fi
success "zsh + starship ready."
