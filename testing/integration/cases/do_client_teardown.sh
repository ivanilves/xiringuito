function get_client_links(){
  ip link | egrep "tun[0-9]{1,2}" | cut -f2 -d' ' | tr '\n' ' '
}

INIT_DELAY=2
DOWN_DELAY=2

ORIG_LINKS=$(get_client_links)

${XIRI_EXE} -X -R ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}; sleep ${INIT_DELAY}
NEW_LINKS=$(get_client_links)

kill ${XIRI_PID}; sleep ${DOWN_DELAY}
if [[ $(ps -p ${XIRI_PID} | wc -l) -eq 2 ]]; then
  kill -9 ${XIRI_PID} &>/dev/null
  sleep ${DOWN_DELAY}
fi
FINAL_LINKS=$(get_client_links)

if [[ "${ORIG_LINKS}" == "${NEW_LINKS}" ]]; then
  complain "TUNx link state should change after xiringuito started and connected!"
  complain "* Original : ${ORIG_LINKS}"
  complain "* New      : ${NEW_LINKS}"
  exit 1
fi

if [[ "${ORIG_LINKS}" != "${FINAL_LINKS}" ]]; then
  complain "TUNx link state should be restored after xiringuito stop!"
  complain "* Original : ${ORIG_LINKS}"
  complain "* Final    : ${FINAL_LINKS}"
  exit 1
fi
