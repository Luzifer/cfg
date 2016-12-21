#!/bin/bash

PUB_CONFIG="git@github.com:Luzifer/cfg.git"
SEC_CONFIG="git@github.com:Luzifer/cfg-secret.git"

if ! [ -d ${HOME}/.cfg/public ]; then
  git clone --bare ${PUB_CONFIG} ${HOME}/.cfg/public
fi

if ! [ -d ${HOME}/.cfg/secret ]; then
  git clone --bare ${SEC_CONFIG} ${HOME}/.cfg/secret
fi

function config {
  git --git-dir=${HOME}/.cfg/${REPO}/ --work-tree=${HOME} $@
}

for REPO in public secret; do
  config checkout
  if [ $? = 0 ]; then
    echo "Checked out config.";
    else
      echo "Backing up pre-existing dot files.";
      config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  fi;
  config checkout
  config config status.showUntrackedFiles no
  config pull
  config submodule update --init --recursive
done
