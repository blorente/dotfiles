function maybe_dotslash_bazel() {
        if [[ -f "./bazel" ]] ; then
                ./bazel $@
        else
                bazel $@
        fi
}

alias bqb="maybe_dotslash_bazel query --output build "
alias bb="maybe_dotslash_bazel build "
alias bt="maybe_dotslash_bazel test "
