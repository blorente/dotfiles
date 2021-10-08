function get_emoji()  {
  if [ $? -gt 0 ]; then
    echo "🙈⚠️ "
  else
    echo "🐈✨"
  fi
}
git_project=$(basename $(git rev-parse --show-toplevel))
git_branch=$(git rev-parse --abbrev-ref HEAD)

# Refs:
#  - Effects: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Visual-effects
#  - Colors: https://jonasjacek.github.io/colors/

export PS1="%B%K{grey}$(get_emoji) %F{silver}|%f $git_project%F{grey}@%f%1d %F{silver}|%f $git_branch%k %F{lime}❯%f%b "
