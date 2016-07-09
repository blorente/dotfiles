#!/usr/bin/bash

# Get current dir

echo "Locating dotfiles dir..."
export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"
echo "Dotfiles are in ${DOTFILES_DIR}"

# Update dotfiles itself first

echo "Updating dotfiles from remote..."

[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks

echo "Creating symlinks..."

ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.bashrc"~
ln -sfv "$DOTFILES_DIR/system/.alias" ~
#ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
