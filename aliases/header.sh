alias v='nvim '
alias l='~/.local/bin/lvim '

# Reload headers
alias reload_term="source ~/.zshrc"

# Easy access to dotfiles
alias godot="cd \$HOME/dotfiles && \$EDITOR ."

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

alias push_tmp="pushd $(mktemp -d)"

function run_and_say() {
  $@
  say -v Victoria "Command finished"
}
alias ras="run_and_say "

function check_input_has() {
  wanted="$1"
  cat /dev/stdin | grep "${wanted}" > /dev/null
}

alias chin="check_input_has "

alias cdr="cd $(git rev-parse --show-toplevel)"

# Imports
PATH="$PATH:/home/blorente/.conscript/bin"
#source "$HOME/dotfiles/aliases/light_prompt.sh"
source "$HOME/dotfiles/aliases/git.sh"
source "$HOME/dotfiles/aliases/common.sh"
source "$HOME/dotfiles/aliases/pants.sh"
source "$HOME/dotfiles/aliases/jars.sh"
source "$HOME/dotfiles/aliases/bazel.sh"
source "$HOME/dotfiles/aliases/tmux.sh"
source "$HOME/dotfiles/aliases/writing.sh"
source "$HOME/dotfiles/aliases/kube.sh"
source "$HOME/dotfiles/aliases/sha.sh"
