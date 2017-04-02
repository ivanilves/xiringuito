#!/usr/bin/env bash
#
# Ping server tunnel endpoint from client
#
set -e

if [[ ${#} != 2 ]]; then
    echo "Usage: ${0} TUNNEL_ID IP_BASE"
    exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}

let SERVER_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+2"
declare -r SERVER_IP_ADDR=${IP_BASE}.${SERVER_LAST_IP_ADDR_OCTET}

ping -c1 -nq ${SERVER_IP_ADDR} >/dev/null
