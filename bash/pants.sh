
function pants_test() {
        (
        set -ex
        relative_path=$1
        test_name=$2

        ./pants --owner-of=tests/python/${relative_path} test -- -s -k ${test_name}
        )
}

alias pt="pants_test "

function _pantsd_watch() {
        watch -n0.3 'ps aux | grep "pantsd.* \[$( pwd )\] \| pantsd-runner \[" | grep -v watch | grep -v tail | grep -v grep'
}
alias pantsd_watch="_pantsd_watch"
