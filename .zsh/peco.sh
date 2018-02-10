# Helpers
function exists { which $1 &> /dev/null }

# kill process
function peco-kill-process() {
  local procs
  procs=$(ps ax -o pid,user,time,command | peco --query "$LBUFFER" | awk '{print $1}')
  if [ -n "${procs}" ]; then
    echo "${procs}" | xargs kill
  fi
}
alias killp='peco-kill-process'

# select history
function peco-select-history() {
	local tac
	exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
	BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
	CURSOR=$#BUFFER         # move cursor
	zle -R -c               # refresh
}
zle -N peco-select-history
bindkey '^R' peco-select-history
