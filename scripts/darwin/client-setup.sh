#!/usr/bin/env bash
#
# Setup client before establishing connection (MacOSX version)
#
set -e

if [[ ${#} -ne 3 ]]; then
  echo "Usage: ${0} TUNNEL_ID LOCAL_TUNNEL_ID IP_BASE"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r LOCAL_TUNNEL_ID=${2}
declare -r IP_BASE=${3}

declare -r NETWORK_DEVICE=tun${LOCAL_TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
let SERVER_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+2"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}
declare -r SERVER_IP_ADDR=${IP_BASE}.${SERVER_LAST_IP_ADDR_OCTET}

 ifconfig ${NETWORK_DEVICE} ${CLIENT_IP_ADDR} ${SERVER_IP_ADDR} netmask 255.255.255.255

set +e

NETWORK_SERVICE="$($(dirname ${0})/get-network-service-name.sh)"
DNS_SERVERS=$(networksetup -getdnsservers "${NETWORK_SERVICE}")
if [[ "${DNS_SERVERS:0:5}" != "There" ]]; then
  echo ${DNS_SERVERS} | tee /tmp/xiringuito.dns.${LOCAL_TUNNEL_ID} >/dev/null
fi
