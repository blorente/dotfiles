function write() {
  cd ~/writing
  d=$(date +"%Y-%m-%d_%H-%M-%S")
  nvim . -c "edit _scratch/new_${d}.md"
}
