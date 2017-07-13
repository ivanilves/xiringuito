INIT_DELAY=10
DOWN_DELAY=5

MOCKED_ROUTE="172.19.12.0/30"

if [[ -f ${WD}/discover-routes ]]; then
  mv ${WD}/discover-routes /tmp/discover-routes.orig
fi
echo '#!/bin/sh' >${WD}/discover-routes
echo "echo ROUTE:1.1.1.1/32" >>${WD}/discover-routes
chmod +x ${WD}/discover-routes

echo "${MOCKED_ROUTE}" > ~/.xiringuito/routes/${SSH_USER}@${REMOTE_IP}

${XIRI_EXE} -f 1 -c ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!};

set +e
wait_for true ${INIT_DELAY} "ip route | grep ${MOCKED_ROUTE}"
if [[ ${?} -ne 0 ]]; then
  complain "Route not added by route discovery: ${MOCKED_ROUTE}"
  exit 1
fi
set -e

set +e
kill_reliably ${XIRI_PID} ${DOWN_DELAY}
set -e
