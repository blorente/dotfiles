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

alias cppwd="pwd | pbcopy"
function cpabs() {
   target=$1
   readlink -f "$target" | pbcopy
}
