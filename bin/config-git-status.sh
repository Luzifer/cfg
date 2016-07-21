#!/bin/bash

for i in $(ls -1 ${HOME}/.cfg); do
  [ $(git --git-dir=$HOME/.cfg/$i/ --work-tree=$HOME status --porcelain | wc -l) -eq 0 ] || exit 1
done

exit 0
