#

## Installation

```bash
sudo apt install git
git clone https://gitlab.com/kirbo/raspberry-pi-mpjg-streamer.git
cd raspberry-pi-mpjg-streamer
# ./install.sh "/path/to/device" "resolution" "fps" "quality" "port" "auto_focus" "focus_absolute"
./install.sh   "/dev/video2"     "1920x1080"  "30"  "100"     "8080" "0"          "20" # Creates service for video0 with resolution 1920x1080, 30fps, quality=100, auto focus disabled, focus set to 20 and in port 8080
./install.sh   "/dev/video0"     "1280x960"   "30"  "100"     "8081" "0"          "20" # Creates service for video2 with resolution 1280x960,  30fps, quality=100, auto focus enabled,  focus set to 20 and in port 8081
```
