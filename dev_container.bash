#!/bin/bash

THIS_SCRIPT_FOLDER="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

# Function for build
build() {
    docker buildx build \
        -t px4-devcontainer:latest \
        --network="host" \
        --build-arg USER=$USER \
        --build-arg USERID=$(id -u) \
        --build-arg GROUPID=$(id -g) \
        "$@" "$THIS_SCRIPT_FOLDER"
}

# Function for run
run() {
    docker run \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.gitconfig:/home/$USER/.gitconfig:rw \
        -v "${THIS_SCRIPT_FOLDER}":/home/$USER/workspace \
        -v ~/.ccache:/home/$USER/.ccache \
        -v ~/.ssh:/home/$USER/.ssh \
        -v="/etc/group:/etc/group:ro" \
        -v="/etc/passwd:/etc/passwd:ro" \
        -v="/etc/shadow:/etc/shadow:ro" \
        -v "$HOME/.Xauthority:/home/$USER/.Xauthority:rw"  \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY="$DISPLAY" \
        --network=host \
        --privileged \
        --name px4-devcontainer \
        --rm -it px4-devcontainer \
        bash -c "eval $@"
}

# Ensure exactly one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 [build|run] command"
    exit 1
fi

# Check argument and call the appropriate function
case "$1" in
    build)
        build
        ;;
    run)
        run "${@:2}"
        ;;
    *)
        echo "Error: Unsupported argument '$1'. Use 'build' or 'run'."
        exit 1
        ;;
esac
