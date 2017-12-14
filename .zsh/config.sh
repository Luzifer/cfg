## Brew installed binaries
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

## Activate go using gimme if any go version is available
GO_VER=$(curl -sSLf -m 2 'https://latest.luzifer.io/catalog-api/golang/latest.txt?p=version')
if [ -e "${HOME}/.gimme/envs/go${GO_VER}.env" ]; then
  source "${HOME}/.gimme/envs/go${GO_VER}.env"
else
  echo "Your Go version is outdated (latest would be ${GO_VER})"
  source "${HOME}/.gimme/envs/latest.env"
fi

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
alias alpine='docker run --rm -ti alpine /bin/sh'
alias gometalinter='gometalinter --enable-all -D aligncheck -D errcheck -D lll --cyclo-over=15 -e bindata.go --vendor'
alias mysql='docker run --rm -ti -v $(pwd):$(pwd) -w $(pwd) mysql bash'
alias :q='exit'
alias share='AWS_REGION=us-east-1 vault2env --key=secret/aws/private -- share --bucket=share-luzifer-io-s3bucket-164ztrtyq1f35 --base-path="file/{{ printf \"%.6s\" .Hash}}" --base-url="https://share.luzifer.io/#"'

## Initialize GPG agent
source ${HOME}/.zsh/gpg-agent.plugin.zsh

## Load config-git functions
source ${HOME}/.zsh/config-git.zsh

## Load local-config if available
[ -e ${HOME}/.zsh/local-config.zsh ] && source ${HOME}/.zsh/local-config.zsh

## Clean PATH from duplicates
PATH=$(${HOME}/bin/path-dedup.py)
