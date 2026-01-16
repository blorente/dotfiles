
function install_binary_to_home() {
  bin="$1"
  if [[ ! -f "${bin}" ]]; then
    echo "ERROR: Binary ${bin} is not a file or doesn't exist"
    exit 1
  fi
  bin_name=$(basename "${bin}")

  dest_name="${2:-${bin_name}}"

  dest="${HOME}/bin"
  mkdir -p "${dest}"
  set -x
  cp "${bin}" "${dest}/${dest_name}"
}

function print_os() {
  uname -s |  tr '[:upper:]' '[:lower:]'
}

function print_arch() {
  uname -m
}
