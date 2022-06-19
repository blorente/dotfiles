function write() {
  f=$1
  cd ~/writing
  if [[ ! "$f" = "" ]]; then
    file_path="$f.md"
  else
    d=$(date +"%Y-%m-%d_%H-%M-%S")
    file_path="new_${d}.md"
  fi
  nvim . -c "edit _scratch/${file_path}"
}
