COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_CYAN="\033[0;36m"
COLOR_YELLOW="\033[0;33m"
COLOR_PLAIN="\033[0m"

function check_util() {
	which ${1} >/dev/null 2>&1 || fail "Missing ${1} util"
}

function error() {
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
	echo -e "${COLOR_CYAN}$@${COLOR_PLAIN}" >&2
}

function step() {
	info "[$(date +%H:%M:%S)] $(printf "%${script_level:-0}s" '' | tr ' ' '+')$@"
}

function success() {
	echo -e "${COLOR_GREEN}$@${COLOR_PLAIN}" >&2
}

function warn() {
	echo -e "${COLOR_YELLOW}$@${COLOR_PLAIN}" >&2
}
