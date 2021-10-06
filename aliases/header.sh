alias v='nvim '

# Silly things
alias train="while : ; do sl -a ; done"
do_timer () {
 termdown --font banner3 --no-seconds --alt-format --title "$2" $( expr 60 \* $1 )
}
alias timer="do_timer"

# FZF things

# Reload headers
alias reload_term="source ~/.zshrc"

# Easy access to dotfiles
alias godot="cd $HOME/dotfiles"

# Imports
PATH="$PATH:/home/blorente/.conscript/bin"
source "$HOME/dotfiles/aliases/prompt.sh"
source "$HOME/dotfiles/aliases/git.sh"
source "$HOME/dotfiles/aliases/pants.sh"
source "$HOME/dotfiles/aliases/jars.sh"
source "$HOME/dotfiles/aliases/bazel.sh"
