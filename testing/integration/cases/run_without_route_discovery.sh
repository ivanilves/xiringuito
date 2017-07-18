INIT_DELAY=20
DOWN_DELAY=10
POST_DELAY=5

MOCKED_ROUTE=10.42.42.0/30

if [[ -f ${WD}/discover-routes ]]; then
  mv ${WD}/discover-routes /tmp/discover-routes.orig
fi

${XIRI_EXE} -f 2 -X ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}
wait_for true ${INIT_DELAY} pgrep -f -- "-w.*${SSH_USER}@${REMOTE_IP}"

sleep ${POST_DELAY}

warn "$(ip route | grep ${MOCKED_ROUTE})"
if [[ -n "$(ip route | grep ${MOCKED_ROUTE})" ]]; then
  complain "Route added by (non-existing) route discovery: ${MOCKED_ROUTE}"
  exit 1
fi

if [[ -f /tmp/discover-routes.orig ]]; then
  mv /tmp/discover-routes.orig ${WD}/discover-routes
fi

set +e
kill_reliably ${XIRI_PID} ${DOWN_DELAY}
set -e

sleep ${POST_DELAY}
