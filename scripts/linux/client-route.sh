#!/usr/bin/env bash
#
# Add client route [after setting up client]
#
set -e

if [[ ${#} -ne 2 ]]; then
  echo "Usage: ${0} TUNNEL_ID NETWORK"
  exit 1
fi

 ip route add ${2} dev tun${1}
