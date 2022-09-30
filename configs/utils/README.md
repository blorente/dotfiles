# Stuffs to do

### Profile a lua script:
```
require'utils.profile'.start("profile.log")

-- code to be profiled

require'utils.profile'.stop()
```
Then, turn it into a flamegraph: 
```
inferno-flamegraph profile.log > flame.svg
```
```
cargo install inferno
```
Shamelessly copied from: https://github.com/nvim-lua/plenary.nvim#plenaryprofile
