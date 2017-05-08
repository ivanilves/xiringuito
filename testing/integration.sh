#!/usr/bin/env bash
#
# Run integration testing suite for Xiringuito
#
cd $(dirname ${0})/integration

declare -r DISTS=$(find . -type f -name "Dockerfile.*" | sed 's/.*\.//')
declare -r CASES=$(ls -1 cases | sed 's/\.sh$//')

function setup(){
  echo
  echo "[ SETUP ]"
  for DIST in ${DISTS}; do
    make docker-start DIST=${DIST}
  done
}

function run_case(){
  declare -r CASE=${1}

  declare -r XIRI_EXE=../../xiringuito
  declare -r SSH_USER=root

  for DIST in ${DISTS}; do
    echo
    echo "[ RUN: ${1} / ${DIST} ]"

    REMOTE_IP=$(make docker-ip DIST=${DIST})

    SSH_EXTRA_OPTS="\
      -oUserKnownHostsFile=/dev/null \
      -oStrictHostKeyChecking=no \
      "

    set -e
    source cases/${1}.sh
    set +e
  done
}

function teardown(){
  echo
  echo "[ TEARDOWN ]"
  for DIST in ${DISTS}; do
    make docker-stop DIST=${DIST}
    make docker-rm DIST=${DIST}
  done
}

if [[ ${#} != 1 ]]; then
  echo "Usage: $(basename ${0}) CASE"
  echo
  echo "Available integration testing cases:"
  echo "${CASES}"
  exit 1
fi

echo '*'
echo "* Case: ${1}"
echo '*'
setup
run_case ${1}
teardown
