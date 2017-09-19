COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_CYAN="\033[0;36m"
COLOR_PLAIN="\033[0m"

function error {
  echo -e "${COLOR_RED}$@${COLOR_PLAIN}"
}

function fail {
  error "Error: $@"
  exit 1
}

function info {
  echo -e "${COLOR_CYAN}$@${COLOR_PLAIN}"
}

function step {
    info "[$(date +%H:%M:%S)] $@"
}

function success {
  echo -e "${COLOR_GREEN}$@${COLOR_PLAIN}"
}
