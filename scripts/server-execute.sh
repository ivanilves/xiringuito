#!/usr/bin/env bash
#
# Execute/teardown on the server side
#
set -e

if [[ ${#} != 2 ]]; then
  echo "Usage: ${0} TUNNEL_ID IP_BASE"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}

declare -r NETWORK_DEVICE=tun${TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}

trap teardown EXIT

function teardown() {
  sudo iptables -t nat -D POSTROUTING -s ${CLIENT_IP_ADDR} -j MASQUERADE

  sudo ip tuntap del mode tun ${NETWORK_DEVICE}
}

echo "CONNECTED"
while true; do
  sleep 60000 # do nothing until interrupted ;)
done
