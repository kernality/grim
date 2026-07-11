#!/usr/bin/env bash
ENABLE_SERVICES_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ENABLE_SERVICES_SCRIPT_PATH/mini_functions.sh"

services_to_enable=(
 dbus NetworkManager bluetoothd polkitd
 tlp thermald chronyd
 socklog-unix nanoklogd
 greetd
)

enable_service() {
 for service in "$@"; do
 if [[ ! -d "/etc/sv/$service" ]]; then
 warning "Service '$service' not in /etc/sv — skipping."; continue
 fi
 if [[ -e "/var/service/$service" ]]; then info "$service already enabled."
 else info "Enabling $service ..."; sudo ln -s "/etc/sv/$service" /var/service/; fi
 done
}
run_function enable_service "${services_to_enable[@]}"

for grp in video input bluetooth _seatd; do
 getent group "$grp" >/dev/null 2>&1 && sudo usermod -aG "$grp" "$USER"
done

# Bluetooth adapter on at boot. bluez installed by now, so main.conf exists.
if [[ -f /etc/bluetooth/main.conf ]]; then
 info "Enabling Bluetooth AutoEnable ..."
 if grep -q '^\[Policy\]' /etc/bluetooth/main.conf; then
 grep -q '^AutoEnable' /etc/bluetooth/main.conf \
 && sudo sed -i 's/^AutoEnable.*/AutoEnable=true/' /etc/bluetooth/main.conf \
 || sudo sed -i '/^\[Policy\]/a AutoEnable=true' /etc/bluetooth/main.conf
 else
 printf '\n[Policy]\nAutoEnable=true\n' | sudo tee -a /etc/bluetooth/main.conf >/dev/null
 fi
fi

success "Services enabled. greetd starts the graphical login on next boot."
