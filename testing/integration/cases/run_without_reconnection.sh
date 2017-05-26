INIT_DELAY=5

${XIRI_EXE} -f 1 -X -R ${SSH_USER}@${REMOTE_IP} 10.245.245.245/32 &
XIRI_PID=${!}; sleep ${INIT_DELAY}

docker restart xiri-${DIST}

sleep ${INIT_DELAY}

warn "$(ip route | grep 10.245.245.245)"
if [[ -n "$(ip route | grep 10.245.245.245)" ]]; then
  complain "Routing not down, but it should be!"
  exit 1
fi
