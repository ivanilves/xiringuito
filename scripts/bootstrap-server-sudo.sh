#!/usr/bin/env bash
#
# Bootstrap ers.d config on server side before doing anything else!
#
set -eo pipefail

if [[ ${#} -lt 1 ]]; then
  echo "Usage: ${0} [OPTIONS] [SSH_USER@]SSH_SERVER"
  exit 1
fi

declare -r SUDO_CONF="'ALL=(ALL) NOPASSWD:ALL'"
declare -r SUDO_NOTE="'# Managed by xiringuito, DO NOT EDIT!!!'"
declare -r BASE_NAME=/etc/ers.d/xiringuito
declare -r STDOUTERR=/tmp/xiringuito.$(basename ${0}).${USER}

ssh -t -oStrictHostKeyChecking=no ${@} \
  " true &&  bash -c \
    \"umask 0337 && echo -e ${SUDO_NOTE}'\n'\${USER} ${SUDO_CONF} | tee ${BASE_NAME}-\${USER}\" >/dev/null" \
    &>${STDOUTERR} || (cat ${STDOUTERR} >>/dev/stderr && exit 1)
