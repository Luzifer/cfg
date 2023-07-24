#!/usr/bin/env bash
set -euo pipefail

[ ${BASH_VERSINFO[0]:-0} -lt 4 ] && {
  echo "Bash too old, update to >=4.0"
  exit 1
}

SYSTEM=$(uname -s | tr 'A-Z' 'a-z')

FORCE=0
typeset -A REPOS
REPOS=(
  [public]='https://git.luzifer.io/luzifer/cfg.git#master'
  [secret]='https://git.luzifer.io/luzifer/cfg-secret.git#master'
)

# --- OPT parsing ---

while getopts "f" opt; do
  case "$opt" in
  f)
    FORCE=1
    ;;
  esac
done

shift $((OPTIND - 1))
[ "${1:-}" = "--" ] && shift

# --- OPT parsing ---

if [ -e ${HOME}/bin/script_framework.sh ]; then
  source ${HOME}/bin/script_framework.sh
else
  function step() { echo "$@"; }
  function fatal() {
    echo "$@"
    exit 1
  }
fi

function config() {
  git --git-dir="${HOME}/.cfg/${repo_name}" --work-tree="${HOME}" $@
}

for repo_name in "${!REPOS[@]}"; do
  clone_url=$(echo ${REPOS[$repo_name]} | cut -d '#' -f 1)
  branch=$(echo ${REPOS[$repo_name]} | cut -d '#' -f 2)

  step "Working on '${repo_name}' (remote: '${clone_url}', branch: '${branch}'..."

  # Clone repo if it's not already available
  if ! [ -d "${HOME}/.cfg/${repo_name}" ]; then
    git clone --bare "${clone_url}" --branch "${branch}" "${HOME}/.cfg/${repo_name}"
  fi

  # Set basic git options for the repo
  config config status.showUntrackedFiles no

  # Do not overwrite local changes
  if (! config diff --exit-code 2>&1 >/dev/null) && [ ${FORCE} -eq 0 ]; then
    error "Repo '${repo_name}' has unsaved changes and force-flag is not set"
    continue
  fi

  # Refresh latest master
  config fetch -q origin ${branch} || { fatal "Failed to fetch '${repo_name}'"; }

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
