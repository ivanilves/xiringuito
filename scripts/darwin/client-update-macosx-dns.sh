#!/usr/bin/env bash
#
# Update MacOSX DNS
#
NETWORK_SERVICE="$($(dirname ${0})/get-network-service-name.sh)"
DNS_SERVERS=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
echo "* Setting DNS for \"${NETWORK_SERVICE}\": ${DNS_SERVERS}"
sudo networksetup -setdnsservers "${NETWORK_SERVICE}" ${DNS_SERVERS}
