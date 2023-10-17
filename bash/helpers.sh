#!/usr/bin/env bash


# Function for outputting a "info" on the script
info () {
  echo -e "${BOLD}${*}${NORMAL}"
}

# Function for outputting a "step" on the script
step () {
  echo -e "${GREEN}***${DEFAULT}""$(info "${BOLD} ${*}${NORMAL}")"
}

# Function for outputting a "minor step" on the script
minor_step () {
  echo -e "${BOLD}  *${NORMAL} ${*}"
}

# Function to output a "divider"
output_divider() {
  TERMINAL_WIDTH="$(tput cols)"
  PADDING="$(printf '%0.1s' ={1..500})"
  DATE=$(date '+%Y-%m-%d %H:%M:%S')
  TEXT="${1} (${DATE})"
  printf '%*.*s %s %*.*s\n' 0 "$(((TERMINAL_WIDTH-2-${#TEXT})/2))" "$PADDING" "${TEXT}" 0 "$(((TERMINAL_WIDTH-1-${#TEXT})/2))" "${PADDING}"
}

# Function for outputting a "all done" on the script
all_done () {
  echo -e "\n${GREEN}✔${NORMAL} ${BOLD}All done${NORMAL}"
}

# Function to check did the previous command succeed or not
continue_if_succeeded () {
  # Get the exit code of previous command
  RESULT=$?
  
  # If it did not exit with code 0 (succesful)
  if [ "$RESULT" != 0 ]; then
    # Run "hard_fail" function and pass the arguments
    hard_fail "Failed" $RESULT
  fi
}

# Output an error
step_failed () {
  # First argument is Message, by default it is "Failed"
  MESSAGE=${1:-"Failed"}
  # Second argument is the exit code, by default it is 1
  STATUS=${2:-1}
  
  # Define the error message prefix/suffix
  ERROR="${BLINK}${BOLD}${RED}!!!${NORMAL}"
  
  # Echo the error message with prefix & suffix and exit with given status code
  echo -e "${ERROR} ${MESSAGE} ${ERROR}"
}

# Output an error
hard_fail () {
  # First argument is Message, by default it is "Failed"
  MESSAGE=${1:-"Failed"}
  # Second argument is the exit code, by default it is 1
  STATUS=${2:-1}
  
  step_failed "${MESSAGE}" "${STATUS}"
  exit "${STATUS}"
}


_cd () {
  cd "${*}" || exit
}
