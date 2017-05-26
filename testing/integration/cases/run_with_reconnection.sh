INIT_DELAY=5
DOWN_DELAY=5

${XIRI_EXE} -f 1 -X ${SSH_USER}@${REMOTE_IP} 10.245.245.245/32 &
XIRI_PID=${!}; sleep ${INIT_DELAY}

docker restart xiri-${DIST}

sleep ${INIT_DELAY}

warn "$(ip route | grep 10.245.245.245)"
if [[ -z "$(ip route | grep 10.245.245.245)" ]]; then
  complain "Routing not restored after reconnection!"
  exit 1
fi

kill_reliably ${XIRI_PID} ${DOWN_DELAY}
