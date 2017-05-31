export EXIT_AFTER_CONNECT=1

${XIRI_EXE} -k ${PWD}/ssh-keys/id_rsa -X ${SSH_USER}@${REMOTE_IP}
