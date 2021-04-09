#!/usr/bin/env bash
#
# Setup server before establishing connection
#
set -e

if [[ ${#} != 2 ]]; then
  echo "Usage: ${0} TUNNEL_ID IP_BASE"
  exit 1
fi

declare -r TUNNEL_ID=${1}
declare -r IP_BASE=${2}

declare -r NETWORK_DEVICE=tun${TUNNEL_ID}
let CLIENT_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+1"
let SERVER_LAST_IP_ADDR_OCTET="4*(${TUNNEL_ID}-1)+2"
declare -r CLIENT_IP_ADDR=${IP_BASE}.${CLIENT_LAST_IP_ADDR_OCTET}
declare -r SERVER_IP_ADDR=${IP_BASE}.${SERVER_LAST_IP_ADDR_OCTET}

declare -r SSHD_CONFIG_FILE=/etc/ssh/sshd_config

if [[ ! $(echo "${PATH}" | egrep "(^|:)/sbin($|:)") ]]; then
  export PATH="/sbin:${PATH}"
fi

if [[ -x /bin/systemctl && -f /lib/systemd/system/ssh.service ]]; then
  declare -r SSHD_RESTART_CMD="systemctl reload ssh"
elif [[ -f /etc/init/ssh.conf ]]; then
  declare -r SSHD_RESTART_CMD="reload ssh"
elif [[ -x /etc/init.d/sshd ]]; then
  declare -r SSHD_RESTART_CMD="/etc/init.d/sshd reload"
elif [[ -x /etc/init.d/ssh ]]; then
  declare -r SSHD_RESTART_CMD="/etc/init.d/ssh reload"
fi

# Ensure previous tunnels with the same ID are not running
set +e
pkill -f ${TUNNEL_ID}/server-execute.sh
if [[ ${?} -eq 0 ]]; then sleep 2; fi
[[ ! -x /usr/sbin/tunctl ]] &&  ip tuntap del mode tun ${NETWORK_DEVICE} ||  /usr/sbin/tunctl -d ${NETWORK_DEVICE}
set -e

# Set up network device
if [[ ! $( ip link | grep " ${NETWORK_DEVICE}: ") ]]; then
   modprobe tun

  if [[ ! -x /usr/sbin/tunctl ]]; then
    set +e
     ip tuntap add mode tun user ${USER} ${NETWORK_DEVICE}
    if [[ ${?} -ne 0 ]]; then
      echo "NB! Failed to add tunX device on the server side!"
      echo "NB! Either you have old or not operational 'iproute2' package installed. :-|"
      echo "NB! If you run old distribution, maybe you need to install 'tunctl' package."
      exit 39
    fi
    set -e
  else
     /usr/sbin/tunctl -u ${USER} -t ${NETWORK_DEVICE}
  fi

   ip link set ${NETWORK_DEVICE} up
   ip addr add ${SERVER_IP_ADDR}/32 peer ${CLIENT_IP_ADDR} dev ${NETWORK_DEVICE}
fi

# Set up SSH server for tunneling
if [[ ! $( grep "^PermitTunnel yes" ${SSHD_CONFIG_FILE}) ]]; then
  echo "PermitTunnel yes" |  tee -a ${SSHD_CONFIG_FILE}
   ${SSHD_RESTART_CMD}
fi

# We need IPv4 forwarding to enable packet traversal
if [[ ! $( sysctl -a 2>/dev/null | grep "net.ipv4.ip_forward.*=.*1") ]]; then
   sysctl -w net.ipv4.ip_forward=1
fi

# We need IPv4 NAT
if [[ ! $( iptables -t nat -nvL POSTROUTING | grep " ${CLIENT_IP_ADDR} ") ]]; then
   iptables -t nat -A POSTROUTING -s ${CLIENT_IP_ADDR} -j MASQUERADE
fi
