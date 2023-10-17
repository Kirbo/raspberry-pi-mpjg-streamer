#!/usr/bin/env bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting

RED="\033[31m"
GREEN="\033[32m"

NORMAL="\033[0m"
DEFAULT="\033[39m"
BLINK="\033[5m"
BOLD="\033[1m"

IP_ADDRESS=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

export RED
export GREEN
export NORMAL
export DEFAULT
export BLINK
export BOLD

export IP_ADDRESS
