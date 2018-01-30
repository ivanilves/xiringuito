#!/usr/bin/env bash
#
# Execute *before* doing anything
#
if [[ -f discover-routes ]]; then
  if [[ "$(shasum discover-routes | cut -f1 -d' ')" == "246d9bbeded14ef58e5bc103af0f8c2e8b2e8cf2" ]]; then
    echo "!!! Rewriting stale 'discover-routes' script"
    cp discover-routes.aws.example discover-routes
  fi

  if [[ "$(shasum discover-routes | cut -f1 -d' ')" == "fce86b790248b5c494c360607d27243768f71ec8" ]]; then
    echo "!!! Rewriting buggy 'discover-routes' script"
    cp discover-routes.aws.example discover-routes
  fi
fi
