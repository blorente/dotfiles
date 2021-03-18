function run_and_say() {
  $@
  res=$?
  if [[ $res == 0 ]]; then
    say "It worked. Success"
  else
    say "Error"
  fi
}

alias ras="run_and_say "
