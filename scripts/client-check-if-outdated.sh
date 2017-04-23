#!/usr/bin/env bash
#
# Check, if we are behind the latest master (and warn, if we are)
# NB! This is a very unusual script, if it fails, nothing breaks!
#
set -e

git remote update >/dev/null

REMOTE_TS=$(git show --pretty="format:%ct" origin/master | head -n1)
LOCAL_TS=$(git show --pretty="format:%ct" | head -n1)

if [[ ${LOCAL_TS} -lt ${REMOTE_TS} ]]; then
  echo "*** WARNING: You are running outdated Xiringuito version. Remember: 'git pull' FTW!"
fi
