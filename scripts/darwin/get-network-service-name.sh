#!/usr/bin/env bash
#
# Get name of the MacOSX network service (device connection)
#
networksetup -listnetworkserviceorder | grep '^(1) ' | sed 's/^(1) //'
