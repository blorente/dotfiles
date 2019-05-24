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

# Editors

alias emacst="emacsclient -t"
alias emacsc="emacsclient -c &"

alias v='nvim '
alias c='code '
# Silly things

alias train="while : ; do sl -a ; done"
do_timer () {
 termdown --font banner3 --no-seconds --alt-format --title "$2" $( expr 60 \* $1 )
}
alias timer="do_timer"

export ANSIBLE_COW_SELECTION=eyes

PATH="$PATH:/home/blorente/.conscript/bin"
source ~/dotfiles/bash/prompt.sh
source ~/dotfiles/bash/git.sh
source ~/dotfiles/bash/pants.sh
source ~/dotfiles/bash/rust.sh
source ~/dotfiles/bash/nyan/header.sh
