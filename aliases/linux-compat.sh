source "$HOME/dotfiles/aliases/lib.sh"

if [[ "$(print_os)" != "linux" ]]; then
  return
fi
# Library of aliases that bring some of the macOS niceties to Linux
alias pbcopy='xclip -selection clipboard'
