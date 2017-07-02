## Brew installed binaries
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

## Activate go using gimme if any go version is available
[ -e ${HOME}/.gimme/envs/latest.env ] && source ${HOME}/.gimme/envs/latest.env

## Custom scripts
export PATH=$HOME/bin:$PATH
source $HOME/.zsh/go-binaries.sh

## Local installed pip package binaries
export PATH=$PATH:$HOME/.local/bin

## Some default settings
export EDITOR=/usr/bin/vim
export BROWSER=/bin/echo # enable usage of `hub browse` on remote machines
export AUTOGOPATH_DEFAULT=$HOME/gocode
export ANSIBLE_NOCOWS=1
export LANG=en_US.UTF-8
export LC_CTYPE=${LANG}
export TZ="Europe/Berlin"

## Map alt+← and alt+→ to move cursor word wise
bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

## Aliases
alias ag='/usr/bin/ag --ignore-dir=vendor'
alias alpine='docker run --rm -ti alpine /bin/sh'
alias gometalinter='gometalinter -D aligncheck -D errcheck -e bindata.go -E misspell --vendor'
alias :q='exit'

## Initialize GPG agent
source ${HOME}/.zsh/gpg-agent.plugin.zsh

## Load config-git functions
source ${HOME}/.zsh/config-git.zsh

## Load local-config if available
[ -e ${HOME}/.zsh/local-config.zsh ] && source ${HOME}/.zsh/local-config.zsh

## Clean PATH from duplicates
PATH=$(python -c 'import os; out=[]; [out.append(i) for i in os.environ["PATH"].split(":") if not out.count(i)]; print ":".join(out)')
