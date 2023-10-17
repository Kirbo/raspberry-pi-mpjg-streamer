#!/usr/bin/env bash

v4l2-ctl -d /dev/DEVICE --all
v4l2-ctl -d /dev/DEVICE --set-ctrl focus_automatic_continuous=AUTO_FOCUS
v4l2-ctl -d /dev/DEVICE --set-ctrl focus_absolute=FOCUS_ABSOLUTE
v4l2-ctl -d /dev/DEVICE --all

/usr/local/bin/mjpg_streamer REPLACE_CONFIGS
