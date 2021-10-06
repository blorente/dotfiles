
function pants_test() {
        (
        set -ex
        relative_path=$1
        test_name=$2

        ./pants --owner-of=tests/python/${relative_path} test -- -s -k ${test_name}
        )
}

alias pt="pants_test "

function pants_test_from_reference() {
        (
        set -ex
        ref="$1"
        # Owner file is the Python package name, with tests/python/pants_test/ prepended, and dots replaced with slashes
        target=$(echo "$ref" | awk -F'.' '{printf "tests/python/pants_test" ; for (i=1; i<NF; i++) printf "/"$i ; print ".py"}')
        testname=$(echo "$ref" | awk -F"#" '{print $2}')

        ./pants --owner-of="$target" test -- -s -k "$testname"
        )
}
alias ptr="pants_test_from_reference "

function _pantsd_watch() {
        watch -n0.3 'ps aux | grep "pantsd.* \[$( pwd )\] \| pantsd-runner \[" | grep -v watch | grep -v tail | grep -v grep'
}
alias pantsd_watch="_pantsd_watch"

alias pantsd="./pants --enable-pantsd "

function _launch_dockerized_pants() {
  (
  set -xe
  pants_location=$1
  docker_image=$2
  cd "${pants_location}"
#  build_hash=$( docker build "build-support/docker/${docker_image}" | tail -n 1 | awk '{print $3}' )
  
  docker run  -v $(realpath "${pants_location}"):/pants -v ~/.cache/pants:/home/.cache/pants  -it "pantsbuild/centos7:latest" /bin/bash
  )
}
alias dockerized_pants="_launch_dockerized_pants $(pwd) "

alias pants_run_binary="(cd $OS_PANTS_SRC/src/rust/engine && ../../../build-support/bin/native/cargo.sh run -p )"
