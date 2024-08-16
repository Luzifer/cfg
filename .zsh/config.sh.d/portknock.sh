# pknock provides a port-knock tool based on ncat
function pknock {
  HOST="$1"

  # Perform port knocking sequence
  echo "Knocking requested port sequence (${HOST} - ${*:2})" >&2
  for i in ${*:2}; do
    ncat -w 50ms "${HOST}" $i 1>/dev/null 2>&1
  done
}
