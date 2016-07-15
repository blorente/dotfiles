#!/usr/bin/bash

# Get current dir

echo "Locating dotfiles dir..."
export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"
echo "Dotfiles are in ${DOTFILES_DIR}"

# Update dotfiles themselves first

echo "Updating dotfiles from remote..."

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Handle shell configurations:
if [ "$( echo $SHELL )" == "usr/bin/zsh" ] || [ "$( echo $SHELL )" == "bin/zsh" ] ; then
  echo "ZSH detected... Loading configuration"
  echo " => Installing Oh-My-Zsh..."
  curl -L http://install.ohmyz.sh | sh
  echo " => Loading configuration file..."
  ln -sfv "$DOTFILES_DIR/runcom/zsh/.zshrc" ~
elif [ "$( echo $SHELL )" == "/bin/bash" ]; then
  echo "BASH detected... Loading configuration"
  ln -sfv "$DOTFILES_DIR/runcom/bash/.bash_profile" ~
  ln -sfv "$DOTFILES_DIR/runcom/bash/.inputrc" ~
  ln -sfv "$DOTFILES_DIR/runcom/bash/.bashrc" ~
  ln -sfv "$DOTFILES_DIR/system/.alias" ~
fi

# Git configuration
echo "Establishing git configuration..."
echo " => .gitconfig"
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
echo " => .gitignore_global"
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~

# Vim plugins
echo "Installing VIM plugins..."
# Vundle
echo " => Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Copy .vimrc file
echo " => Load .vimrc"
ln -sfv "$DOTFILES_DIR/vim/.vimrc" ~
# Install Vundle plugins
vim +PluginInstall +qall

# YouCompleteMe
#echo " => YouCompleteMe (with semantic completion)"
#pacman -S clang
#pacman -S cmake


#ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
