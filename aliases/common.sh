#!/bin/bash

alias cppwd="readlink -f $(pwd) | tr -d ' ' | tr -d '\r' | pbcopy"
alias cpwd="readlink -f $(pwd) | tr -d ' ' | tr -d '\r' | pbcopy"
function cpabs() {
   target=$1
   readlink -f "$target" | tr -d ' ' | tr -d '\r' | pbcopy
}
function goroot() {
  root=$(git rev-parse --show-toplevel)
  cd "${root}" || return
}

bltool() {
  tools=$(gop blorente/bltools)
  echo $tools
  "$tools/run.sh" "$@"
}

mkscratch() {
  mydir="${HOME}/code/scratch/scratch/$1"
  mkdir -p "${mydir}"
  cd "${mydir}" || exit
  git init
}
