[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey -e
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
bindkey "[b" backward-word
bindkey "[f" forward-word
bindkey "^[[3~" delete-char

# Plugins
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.bash_profile

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Powerlevel10k customization
typeset -g POWERLEVEL9K_VCS_HIDE_TAGS=true

# Persistent history
HISTSIZE=15000              #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=15000              #Number of history entries to save to disk
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

PATH="$PATH:/usr/local/bin"
