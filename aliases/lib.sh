#!/bin/bash

run_and_print_if_failed() {
  command=("${@}")
  out=$("${command[@]}" 2>&1 )
  ret="$?"
  if [[ "$ret" != 0 ]]; then
    echo "$out"
  fi
  return "$ret"
}

spinner() {
  s=$(mktemp)
  this_file="${HOME}/dotfiles/aliases/lib.sh"
  cat <<EOF >"$s"
#!/bin/bash
source "${this_file}"
PATH="$PATH" \
run_and_print_if_failed ${@:2}
EOF
  chmod +x "$s"
  gum spin -s line --show-output --title "$1" "$s"
}

