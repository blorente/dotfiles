function install_python_ls() {
  (set -x
    sudo pip3 install 'python-language-server[rope]' || echo 0
  )
}

function setup_vim() {
  (set -xe
  # Install vim-plug
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  # Link dotfiles
  ln -s ~/dotfiles/vim/vimrc .vimrc

  # Run plugin installation
  vim +PlugInstall +qall

  # Possibly install several language servers
  install_python_ls
  )
}
