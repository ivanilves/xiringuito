#!/usr/bin/env bash
#
# Add client route [after setting up client] (MacOSX version)
#
set -e

if [[ ${#} -ne 2 ]]; then
  echo "Usage: ${0} LOCAL_TUNNEL_ID NETWORK"
  exit 1
fi

sudo route add -net ${2} -interface tun${1}
