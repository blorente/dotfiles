#!/bin/bash
set -euo pipefail
this_dir=$(pwd)
tmp_dir=$(mktemp -d)
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
./nvim-macos/bin/nvim
