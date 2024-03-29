COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_CYAN="\033[0;36m"
COLOR_YELLOW="\033[0;33m"
COLOR_PLAIN="\033[0m"
COLOR_PURPLE="\033[35m"

function check_util() {
  command -v ${1} >/dev/null 2>&1 || fail "Missing ${1} util"
}

function check_utils() {
  for util in "$@"; do
    check_util "${util}"
  done
}

function debug() {
  log_level_matches 0 || return 0
  echo -e "${COLOR_PURPLE}$@${COLOR_PLAIN}"
}

function error() {
  log_level_matches 3 || return 0
  echo -e "${COLOR_RED}$@${COLOR_PLAIN}" >&2
}

function fail() {
  error "$@"
  exit 1
}

function fatal() {
  fail "$@"
}

function info() {
  log_level_matches 1 || return 0
  echo -e "${COLOR_CYAN}$@${COLOR_PLAIN}" >&2
}

function join_by() {
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
}

function log_level_matches() {
  declare -A log_levels=(
    [debug]=0
    [info]=1
    [warn]=2
    [warning]=2
    [error]=3
  )
  local fb_ll=${log_levels[${DEFAULT_LOG_LEVEL:-info}]}
  [ ${log_levels[${LOG_LEVEL:-UNDEF}]:-${fb_ll}} -le ${1} ] && return 0 || return 1
}

function step() {
  info "[$(date +%H:%M:%S)] $(printf "%${script_level:-0}s" '' | tr ' ' '+')$@"
}

function success() {
  log_level_matches 1 || return 0
  echo -e "${COLOR_GREEN}$@${COLOR_PLAIN}" >&2
}

function warn() {
  log_level_matches 2 || return 0
  echo -e "${COLOR_YELLOW}$@${COLOR_PLAIN}" >&2
}
