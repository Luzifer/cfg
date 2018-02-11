#!/bin/bash
set -euo pipefail

FORCE=0
PUB_CONFIG="git@github.com:Luzifer/cfg.git"
SEC_CONFIG="git@github.com:Luzifer/cfg-secret.git"

# --- OPT parsing ---

while getopts "f" opt; do
  case "$opt" in
    f)
      FORCE=1
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

# --- OPT parsing ---

if ! [ -d ${HOME}/.cfg/public ]; then
  git clone --bare ${PUB_CONFIG} ${HOME}/.cfg/public
fi

if ! [ -d ${HOME}/.cfg/secret ]; then
  git clone --bare ${SEC_CONFIG} ${HOME}/.cfg/secret
fi

function config {
  git --git-dir=${HOME}/.cfg/${REPO}/ --work-tree=${HOME} $@
}

for REPO in public secret; do
  # Set basic git options for the repo
  config config status.showUntrackedFiles no

  # Do not overwrite local changes
  if ( ! config diff --exit-code 2>&1 >/dev/null ) && [ ${FORCE} -eq 0 ]; then
    echo "Repo '${REPO}' has unsaved changes and force-flag is not set"
    exit 1
  fi

  # Refresh latest master
  config fetch -q origin master || { echo "Failed to fetch '${REPO}'"; exit 1; }

  # Apply latest master
  COMMITS_AHEAD=$(config rev-list --left-right --count FETCH_HEAD...HEAD | awk '{ print $2 }')
  if [ ${COMMITS_AHEAD} -gt 0 ]; then
    echo "Local commits found, trying to rebase..."
    config rebase FETCH_HEAD
  else
    echo "No local commits, resetting to remote master..."
    config reset --hard FETCH_HEAD
  fi

  # Update submodules
  config submodule update --init --recursive
done
