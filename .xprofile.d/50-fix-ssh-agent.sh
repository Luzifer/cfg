# Fix broken ssh-agent after crash
systemctl --user is-active ssh-agent.service | grep -q active || {
  rm -f ~/.ssh/ssh_auth_sock
  systemctl --user restart ssh-agent.service
}
