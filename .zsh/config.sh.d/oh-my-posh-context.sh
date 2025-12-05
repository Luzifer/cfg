function set_poshcontext() {
  # Replacement for config-git-status command segment
  export OMP_CFG_GIT_STATUS="$(~/bin/config-git-status.sh && printf "unmod" || printf "mod")"

  # Replacement for `short_path` command segment
  export OMP_SHORTPATH="$(short_path)"
}
