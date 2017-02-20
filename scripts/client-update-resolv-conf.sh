#!/usr/bin/env bash
#
# Update client's /etc/resolv.conf
#
if [[ ! -f /etc/resolv.conf.orig ]]; then
  sudo cp /etc/resolv.conf /etc/resolv.conf.orig
fi

echo "--- resolv.conf ---"
echo "# Added by xiringuito" | sudo tee /etc/resolv.conf
sudo tee -a /etc/resolv.conf
if [[ ! $(grep "^nameserver 8.8.8.8$" /etc/resolv.conf) ]]; then
  echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
fi
echo "--- resolv.conf ---"
