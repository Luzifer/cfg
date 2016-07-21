for godir in $(cat $HOME/.config/godirs); do
  export PATH=$PATH:${godir}/bin
done
