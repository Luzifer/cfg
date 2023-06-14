# Helpers
function exists() { which $1 &>/dev/null; }

# kill process
function peco-kill-process() {
  local procs
  procs=$(ps ax -o pid,user,time,command | peco --query "$LBUFFER" | awk '{print $1}')
  if [ -n "${procs}" ]; then
    echo "${procs}" | xargs kill
  fi
}
alias killp='peco-kill-process'

# load gpg-key
function peco-load-gpg-key() {
  local keys
  keys=$({
    for keyid in $(vault list secret/gpg-key | tail -n+3); do
      local uid=$({gpg --with-colons -k "${keyid}" 2>/dev/null || echo ""} | awk -F: '$1=="uid" {print $10; exit}')
      [[ -n $uid ]] || continue # Key is not present on machine
      echo "${uid} (${keyid})"
    done
  } | peco --query "$LBUFFER")
  [[ -n $keys ]] || return

  sed -E 's/.*\((.*)\)/\1/' <<<"${keys}" | xargs vault-gpg
}
alias pgpgkey='peco-load-gpg-key'

# load ssh-key
function peco-load-ssh-key() {
  local keys
  keys=$(vault list secret/ssh-key | tail -n+3 | peco --query "$LBUFFER")
  if [ -n "${keys}" ]; then
    echo "${keys}" | xargs vault-sshadd
  fi
}
alias psshkey='peco-load-ssh-key'

# select history
function peco-select-history() {
  local tac
  exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r"; }; }
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER # move cursor
  zle -R -c       # refresh
}
zle -N peco-select-history
bindkey '^R' peco-select-history

# vim: set ft=zsh :
