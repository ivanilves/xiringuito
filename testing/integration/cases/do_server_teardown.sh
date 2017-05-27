function get_server_links(){
  ssh -i ssh-keys/id_rsa ${SSH_EXTRA_OPTS} ${SSH_USER}@${REMOTE_IP} ip link \
    | egrep "tun[0-9]{1,2}" | cut -f2 -d' ' | tr '\n' ' '
}

INIT_DELAY=10
DOWN_DELAY=10

ORIG_LINKS=$(get_server_links)

${XIRI_EXE} -f 1 -X -R ${SSH_USER}@${REMOTE_IP} &
XIRI_PID=${!}; sleep ${INIT_DELAY}
NEW_LINKS=$(get_server_links)

kill_reliably ${XIRI_PID} ${DOWN_DELAY}

FINAL_LINKS=$(get_server_links)

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
