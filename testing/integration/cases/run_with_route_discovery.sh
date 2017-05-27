INIT_DELAY=15
DOWN_DELAY=5
POST_DELAY=5

if [[ -f ${WD}/discover-routes ]]; then
  mv ${WD}/discover-routes /tmp/discover-routes.orig
fi
echo '#!/bin/sh' >${WD}/discover-routes
echo 'echo ROUTE:10.42.42.42/32' >>${WD}/discover-routes
chmod +x ${WD}/discover-routes

${XIRI_EXE} -f 1 ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}; sleep ${INIT_DELAY}

warn "$(ip route | grep 10.42.42.42)"
if [[ -z "$(ip route | grep 10.42.42.42)" ]]; then
  complain "Route not added by route discovery: 10.42.42.42/32"
  exit 1
fi

rm ${WD}/discover-routes
if [[ -f /tmp/discover-routes.orig ]]; then
  mv /tmp/discover-routes.orig ${WD}/discover-routes
fi

set +e
kill_reliably ${XIRI_PID} ${DOWN_DELAY}
set -e

sleep ${POST_DELAY}
