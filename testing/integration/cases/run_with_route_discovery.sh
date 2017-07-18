INIT_DELAY=20
DOWN_DELAY=10
POST_DELAY=2

MOCKED_ROUTE=10.42.42.0/30

if [[ -f ${WD}/discover-routes ]]; then
  mv ${WD}/discover-routes /tmp/discover-routes.orig
fi
echo '#!/bin/sh' >${WD}/discover-routes
echo "echo ROUTE:${MOCKED_ROUTE}" >>${WD}/discover-routes
chmod +x ${WD}/discover-routes

${XIRI_EXE} ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}
set +e
wait_for true ${INIT_DELAY} "ip route | grep ${MOCKED_ROUTE}"
if [[ ${?} -ne 0 ]]; then
  complain "Route not added by route discovery: ${MOCKED_ROUTE}"
  exit 1
fi
set -e

rm ${WD}/discover-routes
if [[ -f /tmp/discover-routes.orig ]]; then
  mv /tmp/discover-routes.orig ${WD}/discover-routes
fi

set +e
kill_reliably ${XIRI_PID} ${DOWN_DELAY}
set -e

sleep ${POST_DELAY}
