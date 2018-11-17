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

function git_describe() {
	git describe --tags 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || printf '\ue701'
}

function awsenv_prompt() {
	local pr=$(awsenv prompt 2>/dev/null)
	[ -z "${pr}" ] || echo "${bracket_open} ${pr} ${bracket_close}"
}

function config-git_prompt() {
	if [ -f ~/bin/config-git-status.sh ]; then
		if ! (~/bin/config-git-status.sh); then
			echo "${bracket_open} %{$fg[red]%} ${bracket_close}"
		fi
	fi
}

function shortened_branch() {
	local branch=$(git_current_branch)
	[ $(echo -n "${branch}" | wc -c) -gt 15 ] && branch="${branch:0:15}%{$fg[red]%}$(printf '\uf141')%{$reset_color%}"
	echo "${branch}"
}

function build_git_prompt() {
	# Allow hiding the right side of the prompt
	(test "${NO_RIGHT}" = "true") && return

	# When there is no git, don't show a git prompt
	git branch >/dev/null 2>/dev/null || return

	# Fetch status of the current repo
	local INDEX=$(command git status --porcelain -b 2>/dev/null)
	local REMOTE=$(command git remote -v | grep fetch)

	echo -n "${bracket_open} %{$fg[blue]%}"

	# Mark specific remotes
	case "${REMOTE}" in
	*bitbucket.org*)
		printf '\ue703 '
		;;
	*github.com*)
		printf '\ue709 '
		;;
	*gitlab.com*)
		printf '\uf296 '
		;;
	*)
		printf '\uf1d3 '
		;;
	esac

	# Show current branch and commit / tag
	echo -n "%{$reset_color%}"
	echo -n "$(shortened_branch) "
	echo -n "($(git_describe)) "

	# Print repository status information
	[ $(echo "$INDEX" | wc -l) -gt 1 ] && echo -n "%{$fg[red]%}$(printf '\uf0f6')%{$FG[236]%} "

	(git rev-parse --verify refs/stash >/dev/null 2>&1) && echo -n "%{$fg[blue]%}$(printf '\uf64c')%{$FG[236]%} "

	# Show difference to remote
	if (echo "$INDEX" | grep '^## .*ahead.*behind' &>/dev/null); then
		echo -n "%{$fg[red]%}$(printf '\uf047')"
	elif (echo "$INDEX" | grep '^## .*ahead' &>/dev/null); then
		echo -n "%{$fg[green]%}$(printf '\uf061')"
	elif (echo "$INDEX" | grep '^## .*behind' &>/dev/null); then
		echo -n "%{$fg[yellow]%}$(printf '\uf060')"
	else
		echo -n "%{$fg[green]%}="
	fi

	echo -n "%{$reset_color%} ${bracket_close}"
}

local current_dir='$(short_path)'
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
╭─ ${prompt_part_time}${prompt_part_user}${prompt_part_configgit}${prompt_part_exit} ${prompt_part_path}
╰─ "

RPROMPT="${git_info}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=""
ZSH_THEME_GIT_PROMPT_SHA_AFTER=""

# vim: set ft=zsh:
