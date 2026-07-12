#!/usr/bin/env bash

info() {
  printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

success() {
  printf '\033[1;32m[OK]\033[0m %s\n' "$*"
}

warning() {
  printf '\033[1;33m[WARN]\033[0m %s\n' "$*"
}

die() {
  printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

enable_service() {
  local name="$1"
  [[ -d "/etc/sv/$name" ]] || die "Required service unavailable: $name"
  sudo ln -sfn "/etc/sv/$name" "/var/service/$name"
}

enable_service_if_present() {
  local name="$1"
  if [[ -d "/etc/sv/$name" ]]; then
    sudo ln -sfn "/etc/sv/$name" "/var/service/$name"
  else
    warning "Optional service unavailable: $name"
  fi
}

run_function() {
  "$@"
  printf '\n%s\n\n' '======================================================================'
}
