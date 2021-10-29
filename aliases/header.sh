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

function list_or_open() {
  file=$1
  if [ "${file}" = "" ]; then
    exa --all --oneline --header --icons "."
  elif [ -f "${file}" ]; then
    less "${file}"
  else
    exa --all --oneline --header --icons "${file}"
  fi
}
alias ls="list_or_open "

# Imports
PATH="$PATH:/home/blorente/.conscript/bin"
source "$HOME/dotfiles/aliases/light_prompt.sh"
source "$HOME/dotfiles/aliases/git.sh"
source "$HOME/dotfiles/aliases/pants.sh"
source "$HOME/dotfiles/aliases/jars.sh"
source "$HOME/dotfiles/aliases/bazel.sh"
