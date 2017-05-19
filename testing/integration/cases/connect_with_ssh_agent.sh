export EXIT_AFTER_CONNECT=1

eval `ssh-agent -s`

ssh-add ssh-keys/id_rsa

${XIRI_EXE} -X ${SSH_USER}@${REMOTE_IP}

kill ${SSH_AGENT_PID}
