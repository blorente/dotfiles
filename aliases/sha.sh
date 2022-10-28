function shaurl() {
  url=$1
  tmpdir=$( mktemp -d )
  file="${tmpdir}/file"
  curl "${url}" -o "${file}"
  sha=$(shasum -a256 "${file}")
  echo "Downloaded to ${file}"
  echo "Shasum:"
  echo "  ${sha}"
}
