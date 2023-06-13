function kubectlgetall {
  local namespace="${1}"
  shift

  for res in $(
    kubectl api-resources --verbs=list --namespaced -o name |
      grep -v "events.events.k8s.io" |
      grep -v "events" |
      sort | uniq
  ); do
    echo "Resource: ${res}" >&2

    kubectl \
      -n ${namespace} \
      get --ignore-not-found \
      "${res}" \
      "${@}"
  done
}
