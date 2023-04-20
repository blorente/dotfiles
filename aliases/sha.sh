function shaurl() {
  url=$1
  tmpdir=$( mktemp -d )
  file="${tmpdir}/file"
  curl -L -n "${url}" -o "${file}"
  sha=$(shasum -a256 "${file}")
  echo "Downloaded to ${file}"
  echo "Shasum:"
  echo "  ${sha}"
  echo "Copying to clipboard..."
  echo "${sha}" | awk '{print $1}' | pbcopy
}
