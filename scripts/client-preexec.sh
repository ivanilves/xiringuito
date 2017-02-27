#!/usr/bin/env bash
#
# Execute *before* doing anything
#
if [[ "$(sha1sum discover-routes | cut -f1 -d' ')" == "246d9bbeded14ef58e5bc103af0f8c2e8b2e8cf2" ]]; then
  echo "!!! Rewriting stale 'discover-routes' script"
  cp discover-routes.aws.example discover-routes
fi
