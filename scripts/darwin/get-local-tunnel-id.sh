#!/usr/bin/env bash
#
# Get local tunnel ID (MacOSX-only hack)
#
LOCAL_TUNNEL_ID=0
while [[ ${LOCAL_TUNNEL_ID} -le 15 ]]; do
  if [[ $(ifconfig | grep "^tun${LOCAL_TUNNEL_ID}: " | wc -l) -eq 0 ]]; then
    echo ${LOCAL_TUNNEL_ID}
    exit 0
  fi

  let LOCAL_TUNNEL_ID+=1
done

echo "No free local tunX device found."
exit 1
