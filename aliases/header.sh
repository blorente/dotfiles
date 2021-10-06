alias v='nvim '

# Silly things
alias train="while : ; do sl -a ; done"
do_timer () {
 termdown --font banner3 --no-seconds --alt-format --title "$2" $( expr 60 \* $1 )
}
alias timer="do_timer"

# FZF things
alias fo='v $(fzf) '
alias vfzf='v $(fzf) '
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse --border'

# Reload headers
alias reload_term="source ~/.zshrc"

# Imports

PATH="$PATH:/home/blorente/.conscript/bin"
source ~/dotfiles/bash/prompt.sh
source ~/dotfiles/bash/git.sh
source ~/dotfiles/bash/pants.sh
source ~/dotfiles/bash/rust.sh
source ~/dotfiles/bash/jars.sh
source ~/dotfiles/bash/bazel.sh
