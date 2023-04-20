alias g="git "

update_master_and_rebase () {
    set -x
    remote=$1
    branch=$(git rev-parse --abbrev-ref HEAD )
    main=${2:-master}
    git stash
    git checkout "$main"
    git fetch $remote
    git pull --ff-only $remote "$main"
    say "updated main brancH"
    git checkout "$branch"
    git rebase "$main"
    res=$?
    if [[ res == 0 ]] ; then
      git stash pop
      say "updated branch"
    fi
    set +x
}
alias guo="update_master_and_rebase origin"
alias guu="update_master_and_rebase upstream"
alias gu="update_master_and_rebase "

alias gst='git status'
alias gsto='git status -uno'
alias gap='git add -p'
alias ga='git add'
alias gcm='git commit -m '
alias gca='git commit --amend '
alias gcan='git commit --amend --no-edit'
alias gl='git log --pretty=oneline'
alias gg='git log --graph --decorate --oneline'
alias gco='git checkout'
function git_create_branch() {
  set -x
  branch_base=$1 # `blorente/` in most cases
  branch_name=$2
  if [[ -z $branch_name ]]; then
    branch="$branch_base"
  else
    branch="$branch_base/$branch_name"
  fi
  git checkout -b $branch
}
alias gcb='git_create_branch '
alias gcbb='git_create_branch blorente '
alias gbb='git_create_branch blorente '

function git_continue_abort() {
  set -x
  command="$1"
  subcommand="$2"
  flag=""
  if [[ $subcommand == "a" ]]; then
    flag='--abort'
  elif [[ $subcommand == "c" ]]; then
    flag='--continue'
  elif [[ $subcommand == "i" ]]; then
    flag='--interactive'
  fi
  git $command $flag "${@:3}"
}
alias gcp='git_continue_abort cherry-pick '
alias grb='git_continue_abort rebase '

alias git_branch_changes='git diff "$(git merge-base master head)"..head'
alias git_branch_log='git log "$(git merge-base master head)"..head'
alias git_branch_log_pretty='git log --graph --decorate --oneline "$(git merge-base master head)"..head'
function git_branch_select {
  git for-each-ref --sort=-committerdate refs/heads/ \
      --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))" \
      | fzf --ansi -n1 | perl -plane 's/(\s|\*)*(\S+).*/$2/' | xargs git checkout
}
alias gbs='git_branch_select'

function save_wip() {
  (
  set -x
  git add .
  head=$(git log -1 --format=%s)
  if [[ "${head}" == "WIP" ]]; then
    git commit --amend --no-edit -n
  else
    git commit -m "WIP" -n
  fi
  )
}
alias gwip='save_wip '

function restore_wip() {
  (
  set -x
  head=$(git log -1 --format=%s)
  if [[ "${head}" == "WIP" ]]; then
    git reset head^
  fi
  )
}
alias gunwip='restore_wip '

function git_unmerge() {
  git add "$@"
  git reset HEAD "$@"
  git checkout "$@"
}

function git::find_missing_symbol_in_file() {
  symbol=$1
  f_ish=$2
  git log -c -S"${symbol}" "**/${f_ish}.*"
}
alias g_find_missing_symbol="git::find_missing_symbol_in_file "
