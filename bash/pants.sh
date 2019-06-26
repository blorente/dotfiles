
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

alias pantsd="./pants --enable-pantsd "

function _launch_dockerized_pants() {
  (
  set -xe
  pants_location=$1
  docker_image=$2
  cd "${pants_location}"
  build_hash=$( docker build "build-support/docker/${docker_image}" | tail -n 1 | awk '{print $3}' )
  docker run  -v $(realpath "${pants_location}"):/pants -v ~/.cache/pants:/home/.cache/pants  -it "${build_hash}" /bin/bash
  )
}
alias dockerized_pants="_launch_dockerized_pants $(pwd) "
