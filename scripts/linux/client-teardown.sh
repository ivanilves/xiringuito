#!/usr/bin/env bash
#
# Teardown client after disconnection [and main program exit]
#
if [[ ${#} -ne 3 ]]; then
  echo "Usage: ${0} XIRINGUITO_PID SSH_PID TUNNEL_ID"
  exit 1
fi

if [[ "${USER}" != "root" ]]; then
  echo "Please run this script by root"
  exit 77
fi

declare -r XIRINGUITO_PID=${1}
declare -r SSH_PID=${2}
declare -r TUNNEL_ID=${3}

while [[ -d /proc/${XIRINGUITO_PID} ]]; do sleep 1; done

if [[ -f /etc/resolv.conf.orig ]]; then
  cp /etc/resolv.conf.orig /etc/resolv.conf
fi

if [[ ${SSH_PID} -ne 0 ]]; then
  kill ${SSH_PID}; sleep 1
fi

ip tuntap del mode tun tun${TUNNEL_ID}
