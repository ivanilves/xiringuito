#!/usr/bin/env bash
#
# Setup client before establishing connection
#
set -e

if [[ ${#} -ne 2 ]]; then
  echo "Usage: ${0} TUNNEL_ID IP_BASE"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}

declare -r NETWORK_DEVICE=tun${TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
let SERVER_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+2"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}
declare -r SERVER_IP_ADDR=${IP_BASE}.${SERVER_LAST_IP_ADDR_OCTET}

if [[ ! $(sudo ip link | grep " ${NETWORK_DEVICE}: ") ]]; then
  sudo modprobe tun
  sudo ip tuntap add mode tun user ${USER} ${NETWORK_DEVICE}
  sudo ip link set ${NETWORK_DEVICE} up
  sudo ip addr add ${CLIENT_IP_ADDR}/32 peer ${SERVER_IP_ADDR} dev ${NETWORK_DEVICE}
fi
