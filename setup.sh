#!/bin/bash
set -x

source ~/dotfiles/vim/setup.sh
source ~/dotfiles/emacs/setup.sh
source ~/dotfiles/bash/setup.sh

cd ~
setup_vim
setup_emacs
setup_bash
