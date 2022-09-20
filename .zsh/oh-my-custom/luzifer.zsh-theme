# luzifer.zsh-theme

# Use with a dark background and 256-color terminal!

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function box_color() {
  [ -f ~/.box_color ] && cat ~/.box_color || ~/bin/color_from_hostname.py
}

function box_name() {
  [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

local current_dir='$(short_path)'
local git_info='$(build_git_prompt)'

local bracket_open="%{$FG[239]%}[%{$reset_color%}"
local bracket_close="%{$FG[239]%}]%{$reset_color%}"

local prompt_part_time="${bracket_open} %T ${bracket_close}"
local prompt_part_user="${bracket_open} %{$FG[040]%}%n%{$reset_color%}%{$FG[239]%}@%{$reset_color%}%{$(box_color)%}$(box_name)%{$reset_color%} ${bracket_close}"
local prompt_part_path="%{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}"
local prompt_part_exit="%(?..${bracket_open} %{$fg[red]%}%?%{${reset_color}%} ${bracket_close})"

PROMPT="
${prompt_part_time}${prompt_part_user}${prompt_part_exit} ${prompt_part_path}
$(printf '\u279c') "

RPROMPT=""

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=""
ZSH_THEME_GIT_PROMPT_SHA_AFTER=""

if command -v oh-my-posh >/dev/null; then
  eval "$(oh-my-posh init zsh --config ~/.zsh/oh-my-custom/oh-my-posh.yaml)"
fi

# vim: set ft=zsh:
