## Brew installed binaries
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

## Custom scripts
export PATH=$HOME/bin:$HOME/.bin:$PATH
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
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

## Map ctrl+← and ctrl+→ to move cursor word wise
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

## Ensure Home and End are working properly
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line

## Aliases
alias alpine='docker run --rm -ti alpine /bin/sh'
alias bcrypt='python3 -c "import bcrypt; import sys; print(bcrypt.hashpw(sys.argv[1].encode(\"utf-8\"), bcrypt.gensalt(10)).decode(\"utf-8\"))"'
alias clasp='docker run --rm -ti -v ~/.config/clasp:/home/node -v $(pwd):$(pwd) -w $(pwd) luzifer/clasp'
alias envrun='envrun --log-level=error'
alias firebase='docker run --rm -ti -v ~/.config/firebase:/home/node/.config -v $(pwd):$(pwd) -w $(pwd) luzifer/firebase-tools'
alias gometalinter='gometalinter --enable-all -D aligncheck -D errcheck -D lll -D gas -D gochecknoglobals -D gochecknoinits -E misspell --cyclo-over=15 -e bindata.go --vendor'
alias gsdk='docker run --rm -ti -v "${HOME}/.config/gcloud:/root/.config/gcloud" -v "${HOME}/.config/gcloud_ssh:/root/.ssh" -v $(pwd):$(pwd) -w $(pwd) google/cloud-sdk:alpine'
alias htpasswd='python3 -c "import crypt; import sys; print(crypt.crypt(sys.argv[1], crypt.mksalt(crypt.METHOD_SHA512)));"'
alias mysql='docker run --rm -ti -v $(pwd):$(pwd) -w $(pwd) mysql bash'
alias mysqlpw='python3 -c "import hashlib; import sys; print(\"*{}\".format(hashlib.sha1(hashlib.sha1(sys.argv[1].encode(\"utf-8\")).digest()).hexdigest().upper()))"'
alias pushgallery='vault2env --key=secret/aws/private -- gallery --storage s3://io-luzifer-photos'
alias :q='exit'
alias share='AWS_REGION=us-east-1 vault2env --key=secret/aws/private -- share --bucket=share-luzifer-io-s3bucket-164ztrtyq1f35 --base-path="file/{{ printf \"%.8s\" .Hash}}" --base-url="https://knut.cc/#" --progress'
alias shfmt='shfmt -d -s -ci'
alias terraria='docker run --rm -ti -v /home/luzifer/tmp/terraria:/data -p 7777:7777 luzifer/terraria'

## Initialize GPG agent
source ${HOME}/.zsh/gpg-agent.plugin.zsh

## Load config-git functions and check for config updates
source ${HOME}/.zsh/config-git.zsh

## Load local-config if available
[ -e ${HOME}/.zsh/local-config.zsh ] && source ${HOME}/.zsh/local-config.zsh

## Load peco functions
source ${HOME}/.zsh/peco.sh

## Clean PATH from duplicates
export PATH=$(${HOME}/bin/path-dedup.py)

## Add custom auto-completions
export fpath=("${HOME}/.zsh/complete" $fpath)
compinit
