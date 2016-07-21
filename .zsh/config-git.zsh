function config {
  git --git-dir=${HOME}/.cfg/public --work-tree=${HOME} $@
}

function config_secret {
  git --git-dir=${HOME}/.cfg/secret --work-tree=${HOME} $@
}
