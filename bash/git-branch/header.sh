function git_branch_diff() {
  set -xe
  git diff $1..head
  set +xe
}

function git_branch() {
  "git_branch_$1" "${@:2}"
}

alias branch="git_branch "
alias bd="git_branch diff "
alias bdm="git_branch diff master"
