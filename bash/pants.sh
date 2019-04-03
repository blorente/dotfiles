
function pants_test() {
        (
        set -ex
        relative_path=$1
        test_name=$2

        target="tests/python/$(echo ${relative_path} | sed 'sX/test_.*X::X')"
        ./pants test ${target} -- -s -k ${test_name}
        )
}

alias pt="pants_test "
