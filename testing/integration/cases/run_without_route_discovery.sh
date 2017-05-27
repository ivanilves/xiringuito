INIT_DELAY=15
DOWN_DELAY=5
POST_DELAY=5

if [[ -f ${WD}/discover-routes ]]; then
  mv ${WD}/discover-routes /tmp/discover-routes.orig
fi

${XIRI_EXE} -f 1 -X ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}; sleep ${INIT_DELAY}

warn "$(ip route | grep 10.42.42.42)"
if [[ -n "$(ip route | grep 10.42.42.42)" ]]; then
  complain "Route added by (non-existing) route discovery: 10.42.42.42/32"
  exit 1
fi

if [[ -f /tmp/discover-routes.orig ]]; then
  mv /tmp/discover-routes.orig ${WD}/discover-routes
fi

set +e
kill_reliably ${XIRI_PID} ${DOWN_DELAY}
set -e

sleep ${POST_DELAY}
