source ~/dotfiles/bash/git-branch/header.sh

update_master_and_rebase () {
    set -x
    remote=$1
    branch=$( git rev-parse --abbrev-ref HEAD )
    git checkout -- pants.ini
    git checkout master
    git fetch $remote
    git pull --rebase $remote master
    say "updated master"
    git checkout "$branch"
    git rebase master
    say "updated branch"
    set +x
}
alias guo="update_master_and_rebase origin"
alias gu="update_master_and_rebase "

find_file () {
	if [ $# -eq 2 ]
  then
  	max_depth="$2"
	  min_depth="$2"
	else
		min_depth=0
		max_depth=1000000
	fi
	find . -name "$1" -maxdepth "$max_depth" -mindepth "$min_depth" 
}
alias ffile="find_file "

open_if_one () {
    results="$1"
    if [[ $(wc -l < <( echo "$results" ) ) -eq 1 ]]
    then
        emacst "$results"
    else
        echo "$results"
    fi
}
rg_and_open () {
    open_if_one $( rg -l "$1" )
}
alias rgo="rg_and_open "
ffile_and_open () {
    res=$( find_file "$1" )
    echo "$res"
    open_if_one "$res"
}
alias fo="ffile_and_open "

alias ctags="`brew --prefix`/bin/ctags"

alias metap="~/coursier launch org.scalameta::metap:3.7.4 -r sonatype:snapshots --"
alias metac='~/coursier launch org.scalameta::metac:3.2.0 -r sonatype:snapshots -- -classpath $(coursier fetch org.scala-lang:scala-library:2.12.4 -p)'
alias metacp='~/coursier launch org.scalameta::metacp:3.7.4 -r sonatype:snapshots --'

alias gst='git status'
alias gap='git add -p'
alias ga='git add'
alias gcm='git commit -m'
alias gpull='git pull'
alias gpush='git push'
alias gl='git log --pretty=oneline'
alias gg='git log --graph --decorate --oneline'
alias gco='git checkout'
alias gph='git push origin head'

alias emacst="emacsclient -t"
alias emacsc="emacsclient -c &"

# Silly things

alias train="while : ; do sl -a ; done"
do_timer () {
 termdown --font banner3 --no-seconds --alt-format --title "$2" $( expr 60 \* $1 )
}
alias timer="do_timer"

source ~/.git-completion.bash

export ANSIBLE_COW_SELECTION=eyes

PATH="$PATH:/home/blorente/.conscript/bin"
source ~/dotfiles/bash/prompt.sh
