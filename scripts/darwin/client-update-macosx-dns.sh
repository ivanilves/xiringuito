#!/usr/bin/env bash
#
# Update MacOSX DNS
#
if [[ ${#} != 1 ]]; then
  echo "Usage: ${0} LOCAL_TUNNEL_ID"
  exit 1
fi

if [[ -f /tmp/xiringuito.dns.${1} ]]; then
  NETWORK_SERVICE="$($(dirname ${0})/get-network-service-name.sh)"
  DNS_SERVERS=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
  echo "* Setting DNS for \"${NETWORK_SERVICE}\": ${DNS_SERVERS}"
  sudo networksetup -setdnsservers "${NETWORK_SERVICE}" ${DNS_SERVERS}
fi
