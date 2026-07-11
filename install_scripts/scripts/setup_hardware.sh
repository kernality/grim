#!/usr/bin/env bash
SETUP_HW_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SETUP_HW_PATH/mini_functions.sh"

info "Enabling the nonfree repository ..."
sudo xbps-install -Sy void-repo-nonfree
sudo xbps-install -Suy

info "Installing Intel graphics + hardware video acceleration ..."
sudo xbps-install -y \
 mesa-dri mesa-vulkan-intel vulkan-loader \
 intel-video-accel libva-utils \
 intel-ucode linux-firmware-intel

info "Installing thermald ..."
sudo xbps-install -y thermald || warning "thermald not installed; skipping."

info "Reconfiguring packages so microcode applies at boot ..."
sudo xbps-reconfigure -fa

success "Intel stack ready. Default VA-API driver: iHD (verify with 'vainfo')."
