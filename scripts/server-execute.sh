#!/usr/bin/env bash
#
# Execute/teardown on the server side
#
if [[ ${#} != 3 ]]; then
  echo "Usage: ${0} TUNNEL_ID IP_BASE MAX_FAILED_PINGS"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}
declare -r MAX_FAILED_PINGS=${3}

declare -r NETWORK_DEVICE=tun${TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}

if [[ ! $(echo "${PATH}" | egrep "(^|:)/sbin($|:)") ]]; then
  export PATH="/sbin:${PATH}"
fi

trap teardown EXIT

function teardown() {
  sudo iptables -t nat -D POSTROUTING -s ${CLIENT_IP_ADDR} -j MASQUERADE
  kill ${PPID}
  sleep 2
  [[ ! -x /usr/sbin/tunctl ]] && sudo ip tuntap del mode tun ${NETWORK_DEVICE} || sudo /usr/sbin/tunctl -d ${NETWORK_DEVICE}
}

echo "CONNECTED"

FAILED_PINGS=0
while [[ ${FAILED_PINGS} -lt ${MAX_FAILED_PINGS} ]]; do
  ping -c3 -nq ${CLIENT_IP_ADDR} >/dev/null
  if [[ ${?} -ne 0 ]]; then
    let FAILED_PINGS+=1
    logger -i -p warn "xiringuito[${TUNNEL_ID}]: Failed to ping ${CLIENT_IP_ADDR} (${FAILED_PINGS}/${MAX_FAILED_PINGS})"
  else
    FAILED_PINGS=0
  fi

  sleep 1
done

teardown
