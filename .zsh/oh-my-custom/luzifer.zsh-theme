# luzifer.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
    echo '○'
}

function box_color {
  [ -f ~/.box_color ] && cat ~/.box_color || ~/bin/color_from_hostname.py
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function git_describe {
  git describe --tags 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo ""
}

function awsenv_prompt {
  local pr=$(awsenv prompt 2>/dev/null)
  [ -z "${pr}" ] || echo "${bracket_open} ${pr} ${bracket_close}"
}

function config-git_prompt {
  if [ -f ~/bin/config-git-status.sh ]; then
    if ! ( ~/bin/config-git-status.sh ); then
      echo "${bracket_open} %{$fg[red]%} ${bracket_close}"
    fi
  fi
}

function build_git_prompt {
  $( test "${NO_RIGHT}" = "true" ) && return
  git branch >/dev/null 2>/dev/null || return
  local INDEX=$(command git status --porcelain -b 2> /dev/null)
  echo -n "${bracket_open} %{$fg[blue]%}"
  local REMOTE=$(command git remote -v | grep fetch)
  (echo "$REMOTE" | grep -q bitbucket.org) && echo -n "B "
  (echo "$REMOTE" | grep -q github.com) && echo -n "G "
  (echo "$REMOTE" | grep -q gitlab.com) && echo -n "L "
  (echo "$REMOTE" | grep -q collins.kg) && echo -n "C "
  echo -n "%{$reset_color%}"
  echo -n "$(git_current_branch) "
  echo -n "($(git_describe)) "
  # Repository status
  echo -n "%{$FG[236]%}"
  ( echo "$INDEX" | grep -E '^\?\? ' &> /dev/null ) && echo -n "%{$fg[blue]%}"
  echo -n "U%{$FG[236]%}"
  ( echo "$INDEX" | grep -E '^(A |M ) ' &> /dev/null ) && echo -n "%{$fg[green]%}"
  echo -n "A%{$FG[236]%}"
  ( echo "$INDEX" | grep -E '^( M|AM| T) ' &> /dev/null ) && echo -n "%{$fg[yellow]%}"
  echo -n "M%{$FG[236]%}"
  ( echo "$INDEX" | grep -E '^R  ' &> /dev/null ) && echo -n "%{$fg[yellow]%}"
  echo -n "R%{$FG[236]%}"
  ( echo "$INDEX" | grep -E '^( D|D |AD) ' &> /dev/null ) && echo -n "%{$fg[red]%}"
  echo -n "D%{$FG[236]%}"
  ( git rev-parse --verify refs/stash >/dev/null 2>&1 ) && echo -n "%{$fg[green]%}"
  echo -n "S%{$FG[236]%}"
  if ( echo "$INDEX" | grep '^## .*ahead.*behind' &> /dev/null ); then
    echo -n "%{$fg[red]%}↔"
  elif ( echo "$INDEX" | grep '^## .*ahead' &> /dev/null ); then
    echo -n "%{$fg[green]%}→"
  elif ( echo "$INDEX" | grep '^## .*behind' &> /dev/null ); then
    echo -n "%{$fg[yellow]%}←"
  else
    echo -n "%{$fg[green]%}="
  fi
  echo -n "%{$reset_color%} ${bracket_close}"
}

local current_dir='$($HOME/bin/short_path)'
local git_info='$(build_git_prompt)'

local bracket_open="%{$FG[239]%}[%{$reset_color%}"
local bracket_close="%{$FG[239]%}]%{$reset_color%}"

local prompt_part_time="${bracket_open} %T ${bracket_close}"
local prompt_part_user="${bracket_open} %{$FG[040]%}%n%{$reset_color%}%{$FG[239]%}@%{$reset_color%}%{$(box_color)%}$(box_name)%{$reset_color%} ${bracket_close}"
local prompt_part_path="%{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}"
local prompt_part_exit="%(?..${bracket_open} %{$fg[red]%}%?%{${reset_color}%} ${bracket_close})"
local prompt_part_char='$(prompt_char)'
local prompt_part_configgit='$(config-git_prompt)'

PROMPT="
╭─ ${prompt_part_time}${prompt_part_user}${prompt_part_configgit}$(awsenv_prompt)${prompt_part_exit} ${prompt_part_path}
╰─${prompt_part_char} "

RPROMPT="${git_info}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=""
ZSH_THEME_GIT_PROMPT_SHA_AFTER=""
