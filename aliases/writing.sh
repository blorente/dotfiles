function write() {
  f=$1
  cd ~/writing
  if [[ ! "$f" = "" ]]; then
    file_path="$f.md"
  else
    d=$(date +"%Y-%m-%d_%H-%M-%S")
    file_path="new_${d}.md"
  fi
  for i in 1 .. 10; do
    echo "\n" >> "${file_path}"
  done
  nvim . -c "edit _scratch/${file_path}" -c "10"
}
