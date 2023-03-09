function maybe_dotslash_bazel() {
        if [[ -f "./bazel" ]] ; then
                ./bazel $@
        else
                bazel $@
        fi
}

alias b="maybe_dotslash_bazel "
alias bqb="maybe_dotslash_bazel query --output build "
alias bb="maybe_dotslash_bazel build "
alias bt="maybe_dotslash_bazel test "

function expand_override_flag() {
  repo_query=$1
  repo_path=$(gop "${repo_query}")
  repo_name=$(basename "${repo_path}")
  echo "--override_repository=${repo_name}=${repo_path}"
}
alias over="expand_override_flag "

function setup_ruleset_with_patches() {
  ruleset_name=$1
  base_ref=$2
  patches=( "${@:3}" )

  ruleset_path=$(gop "${ruleset_name}") 

  cd "${ruleset_path}" || exit
  git fetch upstream
  git checkout "${base_ref}"
  git checkout -b "testing_${ruleset_name}"

  for patch in "${patches[@]}"; do
    echo "$patch"
    git apply "$patch"
    git add .
    git commit -m "Patch: $patch"
  done
}
