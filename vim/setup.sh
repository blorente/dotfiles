function setup_vim() {
  # Install vim-plug
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  # Link dotfiles
  ln -s ~/dotfiles/vim/vimrc .vimrc

  # Run plugin installation
  vim +PlugInstall +qall
}
