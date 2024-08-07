## Brew installed binaries
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

## Custom scripts
export PATH=$HOME/bin:$HOME/.bin:$PATH
source $HOME/.zsh/go-binaries.sh

## Local installed pip package binaries
export PATH=$PATH:$HOME/.local/bin

## Make join_by function globally available
function join_by() {
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
}

## Some default settings
export EDITOR=/usr/bin/nvim
export BROWSER=/bin/echo # enable usage of `hub browse` on remote machines
export AUTOGOPATH_DEFAULT=$HOME/gocode
export ANSIBLE_NOCOWS=1
export LANG=en_US.UTF-8
export LC_CTYPE=${LANG}
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
alias gometalinter='gometalinter --enable-all -D aligncheck -D errcheck -D lll -D gas -D gochecknoglobals -D gochecknoinits -D dupl -D unparam -E misspell --cyclo-over=15 -e bindata.go --vendor'
alias gsdk='docker run --rm -ti -v "${HOME}/.config/gcloud:/root/.config/gcloud" -v "${HOME}/.config/gcloud_ssh:/root/.ssh" -v $(pwd):$(pwd) -w $(pwd) google/cloud-sdk:alpine'
alias htpasswd='python3 -c "import crypt; import sys; print(crypt.crypt(sys.argv[1], crypt.mksalt(crypt.METHOD_SHA512)));"'
alias l='eza --git -lg'
alias ls='/usr/bin/eza'
alias lt='eza --git -lg --tree -I node_modules'
alias markdownlint='dtool markdownlint'
alias mqttcli='eval $(vault2env -e --key=secret/private/mqttcli) && mqttcli'
alias mysql='docker run --rm -ti -v $(pwd):$(pwd) -w $(pwd) mysql bash'
alias mysqlpw='python3 -c "import hashlib; import sys; print(\"*{}\".format(hashlib.sha1(hashlib.sha1(sys.argv[1].encode(\"utf-8\")).digest()).hexdigest().upper()))"'
alias pushgallery='vault2env --key=secret/aws/private -- gallery --storage s3://io-luzifer-photos'
alias :q='exit'
alias repo-add='repo-add -s --key D0391BF9'
alias repo-remove='repo-remove -s --key D0391BF9'
alias scrot='maim -s -u ~/Downloads/screenshot-$(%Y%m%d-%H%M%S).png'
alias shfmt='shfmt -d -s -ci'
alias ssh='ssh-key-host'
alias terraria='docker run --rm -ti -v /home/luzifer/tmp/terraria:/data -p 7777:7777 luzifer/terraria'

## Initialize GPG agent
source ${HOME}/.zsh/gpg-agent.plugin.zsh

## Load config-git functions and check for config updates
source ${HOME}/.zsh/config-git.zsh

## Load local-config if available
[[ -d ${HOME}/.zsh/config.sh.d ]] && {
  for lc in $(find ${HOME}/.zsh/config.sh.d -name '*.zsh' -o -name '*.sh'); do
    [[ -e $lc ]] && source ${lc} || true
  done
} || true

## Load peco functions
source ${HOME}/.zsh/peco.sh

## Load direnv
(which direnv >/dev/null 2>&1) && {
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook zsh)"
}

## Clean PATH from duplicates
export PATH=$(clean-str-dups.py : "${PATH}")

## Add custom auto-completions
export fpath=("${HOME}/.zsh/complete" $fpath)
compinit
