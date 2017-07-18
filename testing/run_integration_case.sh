#!/usr/bin/env bash
#
# Run integration testing suite for Xiringuito
#
cd $(dirname ${0})/integration

chmod -R go-rwx ssh-keys

declare -r DISTS=$(find . -type f -name "Dockerfile.*" | sed 's/.*\.//')
declare -r CASES=$(ls -1 cases | sed 's/\.sh$//')

export PATH=${PATH}:${PWD}/../../helpers

function setup(){
  echo
  echo "[ SETUP ]"
  for DIST in ${DISTS}; do
    make docker-start DIST=${DIST}
  done
}

function kill_reliably(){
  local TARGET_PID=${1}
  local CHECK_DELAY=${2}

  kill ${TARGET_PID}
  TIME_PASSED=0
  while [[ ${TIME_PASSED} -le ${CHECK_DELAY} ]]; do
    if [[ $(ps -p ${TARGET_PID} | wc -l) -eq 2 ]]; then
      sleep 1
      let TIME_PASSED+=1
    else
      sleep 2
      return 0
    fi
  done
  if [[ $(ps -p ${TARGET_PID} | wc -l) -eq 2 ]]; then
    kill -9 ${TARGET_PID} &>/dev/null
    sleep 1
  fi
  sleep 2
}

function warn(){
  local LC=$(echo "${@}" | wc -l)
  local CL=1

  while [[ ${CL} -le ${LC} ]]; do
    echo -e "\033[1;33m$(echo "${@}" | head -n${CL} | tail -n1)\033[0m"
    let CL+=1
  done
}

function complain(){
  echo -e "\033[1;31m>>> ${@}\033[0m"
}

function run_case(){
  declare -r CASE=${1}

  pushd ../.. >/dev/null; WD=${PWD}; popd >/dev/null

  declare -r XIRI_EXE=${WD}/xiringuito
  declare -r SSH_USER=root

  eval `ssh-agent -s`; ssh-add ssh-keys/id_rsa

  for DIST in ${DISTS}; do
    echo
    echo "[ RUN: ${1} / ${DIST} ]"

    REMOTE_IP=$(make docker-ip DIST=${DIST})

    export SSH_EXTRA_OPTS="-oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"

    export LANG=C
    export LC_ALL=C

    [[ "${DEBUG}" == "true" ]] && set -x
    set -e
    source cases/${1}.sh
    set +e
    [[ "${DEBUG}" == "true" ]] && set +x
  done
}

function teardown(){
  set +e
  echo
  echo "[ TEARDOWN ]"
  for DIST in ${DISTS}; do
    make docker-stop DIST=${DIST}
    make docker-rm DIST=${DIST}
  done

  kill ${SSH_AGENT_PID}

  [[ -f /tmp/discover-routes.orig ]] && mv /tmp/discover-routes.orig ${WD}/discover-routes

  if [[ "${SUCCESS}" == "true" ]]; then
    echo
    echo -e "\033[0;32m[ OK ]\033[0m"
    echo
    sleep 1
    exit 0
  fi

  echo
  echo -e "\033[0;31m[ FAIL ]\033[0m"
  echo
  exit 1
}

if [[ ${#} != 1 ]]; then
  echo "Usage: $(basename ${0}) CASE"
  echo
  echo "HINT: Set 'DEBUG' environment variable to see case execution trace."
  echo
  echo "Available integration testing cases:"
  echo "${CASES}"
  exit 1
fi

trap 'teardown' EXIT

echo '*'
echo "* Case: ${1}"
echo '*'
setup
run_case ${1}

SUCCESS=true
