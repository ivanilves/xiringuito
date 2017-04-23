#!/usr/bin/env bash
#
# Check, if we are behind the latest master (and warn if we are)
#
set -e

git remote update >/dev/null

REMOTE_TS=$(git show --pretty="format:%ct" origin master)
LOCAL_TS=$(git show --pretty="format:%ct")

if [[ ${LOCAL_TS} -lt ${REMOTE_TS} ]]; then
  echo "*** WARNING: You are running outdated Xiringuito version. Remember: 'git pull' FTW!"
fi
