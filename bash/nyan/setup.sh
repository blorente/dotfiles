#!/bin/bash
set -xe

source ~/dotfiles/bash/common.sh

function setup_nyan() {
  banner "Setup Nyan"
  github_clone klange/nyancat 
  (
  cd ~/github/klange/nyancat
  make
  cd src
  )
}
