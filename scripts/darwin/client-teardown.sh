#!/usr/bin/env bash
#
# Teardown client after disconnection [and main program exit] (MacOSX version)
#
if [[ ${#} -ne 3 ]]; then
  echo "Usage: ${0} XIRINGUITO_PID SSH_PID LOCAL_TUNNEL_ID"
  exit 1
fi

if [[ "${USER}" != "root" ]]; then
  echo "Please run this script by root"
  exit 77
fi

declare -r XIRINGUITO_PID=${1}
declare -r SSH_PID=${2}
declare -r LOCAL_TUNNEL_ID=${3}

if [[ ${SSH_PID} -eq 0 ]]; then
  kill ${XIRINGUITO_PID} &>/dev/null
fi

while [[ $(ps -p ${XIRINGUITO_PID} | wc -l) -eq 2 ]]; do sleep 1; done

if [[ -f /etc/resolv.conf.orig ]]; then
  cp /etc/resolv.conf.orig /etc/resolv.conf
fi

if [[ ${SSH_PID} -ne 0 ]]; then
  kill ${SSH_PID} &>/dev/null; sleep 1
fi

NETWORK_SERVICE="$($(dirname ${0})/get-network-service-name.sh)"
if [[ -f /tmp/xiringuito.dns.${LOCAL_TUNNEL_ID} ]]; then
  DNS_SERVERS=$(cat /tmp/xiringuito.dns.${LOCAL_TUNNEL_ID})
   networksetup -setdnsservers "${NETWORK_SERVICE}" ${DNS_SERVERS}
  rm /tmp/xiringuito.dns.${LOCAL_TUNNEL_ID}
fi
