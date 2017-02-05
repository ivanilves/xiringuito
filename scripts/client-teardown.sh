#!/usr/bin/env bash
#
# Teardown client after disconnection
#
set -e

if [[ ${#} != 1 ]]; then
  echo "Usage: ${0} TUNNEL_ID"
  exit 1
fi

sudo ip tuntap del mode tun tun${1}
