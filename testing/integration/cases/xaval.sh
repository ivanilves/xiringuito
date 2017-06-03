export EXIT_AFTER_CONNECT=1

local PROFILE_DIR=~/.xiringuito/profiles
local PROFILE=xiri-${DIST}

trap "rm -f ${PROFILE_DIR}/${PROFILE}*; teardown" EXIT

${WD}/xaval create ${PROFILE} ${SSH_USER}@${REMOTE_IP}
warn "$(cat ${PROFILE_DIR}/${PROFILE})"
if [[ "$(cat ${PROFILE_DIR}/${PROFILE})" != "${SSH_USER}@${REMOTE_IP}" ]]; then
  complain "Xaval has not created profile file with valid content: ${PROFILE}"
  exit 1
fi

set +e
${WD}/xaval create ${PROFILE} ${SSH_USER}@${REMOTE_IP}
if [[ ${?} -eq 0 ]]; then
  complain "Xaval has created profile, even when it was already created :-/"
  exit 1
fi
set -e

${WD}/xaval rename ${PROFILE} ${PROFILE}.new
if [[ -f "${PROFILE_DIR}/${PROFILE}" ]]; then
  complain "Xaval [renaming] has not removed old profile file: ${PROFILE_DIR}/${PROFILE}"
  exit 1
fi
if [[ ! -f "${PROFILE_DIR}/${PROFILE}.new" ]]; then
  complain "Xaval [renaming] has not created new profile file: ${PROFILE_DIR}/${PROFILE}"
  exit 1
fi

set +e
${WD}/xaval rename ${PROFILE} ${PROFILE}.new
if [[ ${?} -eq 0 ]]; then
  complain "Xaval has renamed non-existing profile :-/"
  exit 1
fi
set -e

${WD}/xaval rename ${PROFILE}.new ${PROFILE}

${WD}/xaval update ${PROFILE} -X ${SSH_USER}@${REMOTE_IP}
warn "$(cat ${PROFILE_DIR}/${PROFILE})"
if [[ "$(cat ${PROFILE_DIR}/${PROFILE})" != "-X ${SSH_USER}@${REMOTE_IP}" ]]; then
  complain "Xaval has not updated profile file with valid content: ${PROFILE}"
  exit 1
fi

${WD}/xaval connect ${PROFILE}

${WD}/xaval delete ${PROFILE}
if [[ -f "${PROFILE_DIR}/${PROFILE}" ]]; then
  complain "Xaval has not deleted profile file: ${PROFILE_DIR}/${PROFILE}"
  exit 1
fi

set +e
${WD}/xaval delete ${PROFILE}
if [[ ${?} -eq 0 ]]; then
  complain "Xaval has deleted already deleted profile :-/"
  exit 1
fi
set -e
