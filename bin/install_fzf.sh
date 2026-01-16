#!/bin/bash
set -euo pipefail

# The one that happened to be the latest when I wrote this script.
FZF_VERSION="${FZF_VERSION:-"0.67.0"}"

dotfiles_dir="${HOME}/dotfiles"
source "${dotfiles_dir}/bin/lib.sh"

this_dir=$(pwd)
tmp_dir=$(mktemp -d)

os=$(print_os)
arch=$(print_arch)

if [[ "${os}" == "linux" && "${arch}" == "x86_64" ]]; then
  arch="amd64"
fi
if [[ "${os}" == "macos" ]]; then
  os="darwin"
fi

package_name="fzf-${FZF_VERSION}-${os}_${arch}"

pushd "${tmp_dir}"
curl -LO "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/${package_name}.tar.gz"
tar xf "${package_name}.tar.gz"
install_binary_to_home "./fzf" "fzf"

