#!/usr/bin/env bash
#
# Setup client before establishing connection
#
set -e

if [[ ${#} -lt 2 ]]; then
  echo "Usage: ${0} TUNNEL_ID IP_BASE [NETWORK1 NETWORK2 ... NETWORKx]"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}
shift 2
declare -r NETWORKS=${@}

declare -r NETWORK_DEVICE=tun${TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}

if [[ ! $(ip link | grep " ${NETWORK_DEVICE}: ") ]]; then
  sudo modprobe tun
  sudo ip tuntap add mode tun user ${USER} ${NETWORK_DEVICE}
  sudo ip link set ${NETWORK_DEVICE} up
  sudo ip addr add ${CLIENT_IP_ADDR}/30 dev ${NETWORK_DEVICE}
fi

for NETWORK in ${NETWORKS}; do
  echo "> ${NETWORK}"
  sudo ip route add ${NETWORK} dev ${NETWORK_DEVICE}
done
