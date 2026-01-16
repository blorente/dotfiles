#!/bin/bash
set -euo pipefail

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

package_name="bazelisk-${os}-${arch}"

pushd "${tmp_dir}"
set -x
curl -LO "https://github.com/bazelbuild/bazelisk/releases/latest/download/${package_name}"
chmod u+x "${package_name}"
install_binary_to_home "./${package_name}" "bazel"
install_binary_to_home "./${package_name}" "bazelisk"
