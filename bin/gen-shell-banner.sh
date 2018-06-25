#!/bin/bash
set -euo pipefail

function kv() {
  printf "$(boxchar 78) %15s: %-64s $(boxchar 78)\n" "$@"
}


function boxchar() {
  printf "\x1b(0\x$1\x1b(B"
}

## Redirect stdout into shell-banner.txt
exec >${HOME}/.local/shell-banner.txt

## Start output
printf "$(boxchar 6c)%083s$(boxchar 6b)\n" | sed "s/ /$(printf "$(boxchar 71)")/g"

## Check whether config repos needs update
kv "Config" "$(${HOME}/bin/check_config)"

## Check for latest Go version
if ( ping -c 1 -q 8.8.8.8 >/dev/null ); then
  GO_VER=$(curl -sSLf -m 2 'https://lv.luzifer.io/catalog-api/golang/latest.txt?p=version')
  if [ -e "${HOME}/.gimme/envs/go${GO_VER}.env" ]; then
    kv "Go-Version" "Up-to-date (${GO_VER})"
  else
    kv "Go-Version" "Outdated (latest would be ${GO_VER})"
  fi
else
  kv "Go-Version" "Unknown, network unreachable"
fi

## Log generation time
kv "Updated" "$(date +"%Y-%m-%d %H:%M")"

## End output
printf "$(boxchar 6d)%083s$(boxchar 6a)\n" | sed "s/ /$(printf "$(boxchar 71)")/g"
echo # Add an extra blank line
