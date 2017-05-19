export SSH_EXTRA_OPTS="${SSH_EXTRA_OPTS} -i ${PWD}/ssh-keys/id_rsa"
export EXIT_AFTER_CONNECT=1

${XIRI_EXE} -X ${SSH_USER}@${REMOTE_IP}
