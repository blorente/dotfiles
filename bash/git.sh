update_master_and_rebase () {
    set -x
    remote=$1
    branch=$( git rev-parse --abbrev-ref HEAD )
    git checkout -- pants.ini
    git checkout master
    git fetch $remote
    git pull --ff-only $remote master
    say "updated master"
    git checkout "$branch"
    git rebase master
    say "updated branch"
    set +x
}
alias guo="update_master_and_rebase origin"
alias guu="update_master_and_rebase upstream"
alias gu="update_master_and_rebase "

function git_safe_pull () {
  repo=${1:-origin}
  git pull --ff-only $repo $@
}
alias gsp="git_safe_pull "
alias gspu="git_safe_pull upstream "
alias gspo="git_safe_pull origin "

alias gst='git status'
alias gsto='git status -uno'
alias gap='git add -p'
alias ga='git add'
alias gcm='git commit -m'
alias gpull='git pull'
alias gpush='git push'
alias gl='git log --pretty=oneline'
alias gg='git log --graph --decorate --oneline'
alias gco='git checkout'
alias gph='git push origin head'

alias git_branch_changes='git diff "$(git merge-base master head)"..head'
alias git_branch_log='git log "$(git merge-base master head)"..head'
alias git_branch_log_pretty='git log --graph --decorate --oneline "$(git merge-base master head)"..head'
function git_branch_select {
  git for-each-ref --sort=-committerdate refs/heads/ \
      --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))" \
      | fzf --ansi -n1 | perl -plane 's/(\s|\*)*(\S+).*/$2/' | xargs git checkout
}
alias gbs='git_branch_select'

function open_with_hub() {
  hub browse -- issues/$1 
}
alias hub_open='open_with_hub '

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


function backup_and_delete() {
  (
  set -x
  save_wip
  cur_branch=$(git branch | grep \* | cut -d ' ' -f2)
  backup_branch=$(echo "blorente/backups/${cur_branch}")
  if [[ $(git branch | grep "${backup_branch}" | wc -l) -eq 1 ]]; then
    git branch -D "${backup_branch}"
  fi
  git checkout -b "${backup_branch}"
  git branch -D "${cur_branch}"
  git checkout master
  git checkout -b "${cur_branch}"
  )
}
alias git_override_backup="backup_and_delete "

alias git_paste="git commit --amend --no-edit "
alias git_create_empty='git commit -m "Empty commit to trigger Travis" --allow-empty -n '

function _do_gh_clone() {
  (
  repo=$1
  reponame=$(echo ${repo} | awk -F"/" '{print $4"/"$5}')
  dest="${HOME}/github/$reponame"
  set -ex
  git clone ${repo} ${dest}
  )
}
alias gh_clone="_do_gh_clone "
