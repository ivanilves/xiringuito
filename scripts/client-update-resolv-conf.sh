#!/usr/bin/env bash
#
# Update client's /etc/resolv.conf
#
if [[ ! -f /etc/resolv.conf.orig ]]; then
   cp /etc/resolv.conf /etc/resolv.conf.orig
fi

echo "--- resolv.conf ---"
echo "# Added by xiringuito" |  tee /etc/resolv.conf
 tee -a /etc/resolv.conf
if [[ ! $(grep "^nameserver 8.8.8.8$" /etc/resolv.conf) ]]; then
  echo "nameserver 8.8.8.8" |  tee -a /etc/resolv.conf
fi
echo "--- resolv.conf ---"
