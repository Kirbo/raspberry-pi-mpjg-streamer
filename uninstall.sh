#!/usr/bin/env bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BASH_DIR="${ROOT_DIR}/bash"

CAMERA_DEVICE=${1:-"/dev/video0"}
SERVICE=${CAMERA_DEVICE##*/}

# shellcheck source=/dev/null
source "${BASH_DIR}/_main.sh"

step "mjpg-streamer"

minor_step "Stopping mjpg_streamer_${SERVICE} daemon"
sudo systemctl stop "mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Disabling mjpg_streamer_${SERVICE} startup daemon"
sudo systemctl disable "mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Deleting repository"
rm -rf mjpg-streamer

minor_step "Deleting mjpg_streamer_${SERVICE}.service"
sudo rm "/etc/systemd/system/mjpg_streamer_${SERVICE}.service"

minor_step "Deleting startup_${SERVICE}.sh"
rm "startup_${SERVICE}.sh"

step "Do you want to remove the '${GREEN}cmake libjpeg8-dev${NORMAL}' dependencies as well? [y/N]: "
read -rn1 remove_dependencies
if [[ "${remove_dependencies}" == "y" ]]; then
  minor_step "Removing dependencies..."
  sudo apt remove cmake libjpeg8-dev -y
else
  minor_step "Skipped!"
fi

all_done
