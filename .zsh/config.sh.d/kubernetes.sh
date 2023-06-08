function kubectlgetall {
  local namespace="${1}"
  shift

  for i in $(
    kubectl api-resources --verbs=list --namespaced -o name |
      grep -v "events.events.k8s.io" |
      grep -v "events" |
      sort | uniq
  ); do
    echo "Resource:" $i >&2
    kubectl -n ${namespace} get --ignore-not-found ${i} "${@}"
  done
}

# vim: set ft=zsh :
