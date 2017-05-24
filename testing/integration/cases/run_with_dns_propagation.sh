INIT_DELAY=20
DOWN_DELAY=20

ORIG_RESOLV_CONF=$(cat /etc/resolv.conf)
warn "${ORIG_RESOLV_CONF}"

${XIRI_EXE} -f 1 -X -R ${SSH_USER}@${REMOTE_IP} 10.245.245.245/32 &
XIRI_PID=${!}; sleep ${INIT_DELAY}

NEW_RESOLV_CONF=$(cat /etc/resolv.conf)
warn "${NEW_RESOLV_CONF}"

if [[ "${ORIG_RESOLV_CONF}" == "${NEW_RESOLV_CONF}" ]]; then
  complain "Should update /etc/resolv.conf"
  exit 1
fi

kill_reliably ${XIRI_PID} ${DOWN_DELAY}
