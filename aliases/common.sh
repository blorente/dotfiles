#!/bin/bash

function banner() {
  msg="$1"
  echo "[=== ${msg} ===]"
}

function github_clone() {
  repo="$1"
  dest="~/github/${repo}"
  git clone "https://github.com/${repo}" "${dest}" 
  banner "Cloned ${repo}"
}

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
