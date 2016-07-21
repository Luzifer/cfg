#!/usr/local/bin/zsh

_autogopath_find_gopath_marker() {
  SEARCH_PATH=$1
  if [ -e "${SEARCH_PATH}/.gopath" ]; then
    AUTOGOPATH_PATH=${SEARCH_PATH}
    return
  fi

  if ( test "/" = "${SEARCH_PATH}" ); then
    AUTOGOPATH_PATH=""
    return
  fi

  SEARCH_PATH=$(dirname ${SEARCH_PATH})
  _autogopath_find_gopath_marker ${SEARCH_PATH}
}

_autogopath_chpwd_handler() {
  _autogopath_find_gopath_marker $(pwd)
  
  if [ -z "$AUTOGOPATH_PATH" ]; then
    export GOPATH=$AUTOGOPATH_DEFAULT
  else
    export GOPATH=$AUTOGOPATH_PATH
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _autogopath_chpwd_handler

_autogopath_chpwd_handler
