#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"

# NetworkManager must not race other network managers.
for service in dhcpcd wpa_supplicant; do
  if [[ -e "/var/service/$service" || -L "/var/service/$service" ]]; then
    sudo sv down "$service" 2>/dev/null || true
    sudo rm -f -- "/var/service/$service"
  fi
done

# greetd owns tty2.
if [[ -e /var/service/agetty-tty2 || -L /var/service/agetty-tty2 ]]; then
  sudo sv down agetty-tty2 2>/dev/null || true
  sudo rm -f -- /var/service/agetty-tty2
fi

required_services=(
  dbus
  elogind
  NetworkManager
  bluetoothd
  polkitd
  chronyd
  socklog-unix
  nanoklogd
  greetd
)

for service in "${required_services[@]}"; do
  enable_service "$service"
done

for service in tlp thermald rtkit; do
  enable_service_if_present "$service"
done

for group in network bluetooth video input socklog _seatd; do
  if getent group "$group" >/dev/null 2>&1; then
    sudo usermod -aG "$group" "$USER"
  fi
done

if [[ -f /etc/bluetooth/main.conf ]]; then
  if ! grep -q '^\[Policy\]' /etc/bluetooth/main.conf; then
    printf '\n[Policy]\n' |
      sudo tee -a /etc/bluetooth/main.conf >/dev/null
  fi

  if grep -q '^AutoEnable=' /etc/bluetooth/main.conf; then
    sudo sed -i 's/^AutoEnable=.*/AutoEnable=true/' \
      /etc/bluetooth/main.conf
  else
    sudo sed -i '/^\[Policy\]/a AutoEnable=true' \
      /etc/bluetooth/main.conf
  fi
fi

success "Core runit services enabled"
