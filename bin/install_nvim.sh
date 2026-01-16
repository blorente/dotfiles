#!/bin/bash
set -euo pipefail

dotfiles_dir="${HOME}/dotfiles"
source "${dotfiles_dir}/bin/lib.sh"

this_dir=$(pwd)
tmp_dir=$(mktemp -d)

os=$(print_os)
arch=$(print_arch)

package_name="nvim-${os}"
if [[ "$os" == "linux" ]]; then
  package_name="nvim-${os}-${arch}"
fi

pushd "${tmp_dir}"
curl -LO "https://github.com/neovim/neovim/releases/download/stable/${package_name}.appimage"
chmod u+x "${package_name}.appimage"
install_binary_to_home "./${package_name}.appimage" "nvim"

