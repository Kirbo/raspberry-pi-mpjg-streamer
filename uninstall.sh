#!/usr/bin/env bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BASH_DIR="${ROOT_DIR}/bash"

# shellcheck source=/dev/null
source "${BASH_DIR}/_main.sh"

step "Removing dependencies"
sudo apt remove cmake libjpeg8-dev -y

step "mjpg-streamer"

minor_step "Stopping daemon"
sudo systemctl stop mjpg_streamer
continue_if_succeeded

minor_step "Disabling startup daemon"
sudo systemctl disable mjpg_streamer
continue_if_succeeded

minor_step "Killing mjpg_streamer process"
kill -9 "$(ps aSux | pgrep mjpg_streamer)"

minor_step "Deleting repository"
rm -rf mjpg-streamer

all_done
