#!/usr/bin/env bash

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BASH_DIR="${ROOT_DIR}/bash"

CAMERA_DEVICE=${1:-"/dev/video0"}
CAMERA_RESOLUTION=${2:-"1920x1080"}
CAMERA_FPS=${3:-"30"}
CAMERA_QUALITY=${4:-"100"}
MJPG_STREAMER_PORT=${5:-"8085"}
AUTO_FOCUS=${6:-"0"}
FOCUS_ABSOLUTE=${7:-"20"}

SERVICE=${CAMERA_DEVICE##*/}

# shellcheck source=/dev/null
source "${BASH_DIR}/_main.sh"

step "Installing dependencies"
sudo apt-get install cmake libjpeg62-turbo-dev -y
continue_if_succeeded

step "mjpg-streamer"
if ! [ -d "mjpg-streamer" ]; then
  minor_step "Cloning repository"
  (rm -rf mjpg-streamer ; git clone https://github.com/jacksonliam/mjpg-streamer.git)
  continue_if_succeeded
else
  minor_step "Updating repository"
  (_cd mjpg-streamer ; git pull)
  continue_if_succeeded
fi

minor_step "Make build"
(
  _cd mjpg-streamer/mjpg-streamer-experimental/
  make
  sudo make install
)
continue_if_succeeded

minor_step "Check if mjpg_streamer is found"
(
  _cd ~
  which mjpg_streamer
  ls /usr/local/lib/mjpg-streamer
)
continue_if_succeeded

step "Testing mjpg_streamer"
INPUT_PARAMETERS="input_uvc.so -d ${CAMERA_DEVICE} -r ${CAMERA_RESOLUTION} -f ${CAMERA_FPS} -q ${CAMERA_QUALITY}"
OUTPUT_PARAMETERS="output_http.so -p ${MJPG_STREAMER_PORT} -w /usr/local/share/mjpg-streamer/www"
PARAMETERS="-i '${INPUT_PARAMETERS}' -o '${OUTPUT_PARAMETERS}'"
/usr/local/bin/mjpg_streamer -b -i "${INPUT_PARAMETERS}" -o "${OUTPUT_PARAMETERS}"
continue_if_succeeded
echo "Open in browser to see if it's working http://${IP_ADDRESS}:${MJPG_STREAMER_PORT}/?action=stream"

read -r -n 1 -p "Press any key to kill the stream and continue installation..."
echo
kill -9 "$(ps aSux | pgrep mjpg_streamer)"

## Startup.sh
minor_step "Copying ${GREEN}startup.sh${DEFAULT} into ${GREEN}startup_${SERVICE}.sh${DEFAULT}"
cp original/startup.sh "startup_${SERVICE}.sh"
chmod +x "startup_${SERVICE}.sh"
continue_if_succeeded

minor_step "Replacing parameters in ${GREEN}startup_${SERVICE}.sh${DEFAULT}"
sed -i "s#REPLACE_CONFIGS#${PARAMETERS}#g" "startup_${SERVICE}.sh"
sed -i "s#AUTO_FOCUS#${AUTO_FOCUS}#g" "startup_${SERVICE}.sh"
sed -i "s#FOCUS_ABSOLUTE#${FOCUS_ABSOLUTE}#g" "startup_${SERVICE}.sh"
sed -i "s#DEVICE#${SERVICE}#g" "startup_${SERVICE}.sh"
continue_if_succeeded

## Startup.service
minor_step "Copying ${GREEN}startup.service${DEFAULT} into ${GREEN}mjpg_streamer_${SERVICE}.service${DEFAULT}"
cp original/startup.service "mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Replacing parameters in ${GREEN}mjpg_streamer_${SERVICE}.service${DEFAULT}"
sed -i "s#\[PATH_TO\]#$(pwd)#g" "mjpg_streamer_${SERVICE}.service"
sed -i "s#\[DEVICE\]#${SERVICE}#g" "mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Moving ${GREEN}mjpg_streamer_${SERVICE}.service${DEFAULT} into ${GREEN}/etc/systemd/system/mjpg_streamer_${SERVICE}.service${DEFAULT}"
sudo mv "mjpg_streamer_${SERVICE}.service" "/etc/systemd/system/mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Enabling mjpg_streamer on startup"
sudo systemctl enable "mjpg_streamer_${SERVICE}.service"
continue_if_succeeded

minor_step "Starting daemon"
sudo systemctl restart "mjpg_streamer_${SERVICE}"
continue_if_succeeded

minor_step "Check status"
sudo systemctl status "mjpg_streamer_${SERVICE}"
continue_if_succeeded

all_done
