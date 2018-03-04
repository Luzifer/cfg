function config {
  repo_name=$1
  shift

  if ! [ -d ${HOME}/.cfg/${repo_name} ]; then
    echo "Repo '${repo_name}' not found!"
    return 1
  fi

  git --git-dir=${HOME}/.cfg/${repo_name} --work-tree=${HOME} $@
}

