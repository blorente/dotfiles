for DOTFILE in `find /Users/borja/.dotfiles`
do
 [ -f "$DOTFILE" ] && source "$DOTFILE"
done

export ANDROID_HOME="/opt/android-sdk"
