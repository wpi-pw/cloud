#!/bin/bash

# WPI Cloud - source
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

# Check for a registered commands
case "$1" in
  init | help);;
  *)  printf "${RED}Warning:${NC} '%s' is not a registered wpi command. See 'wpi help'. \n" "$1" && exit 1 ;;
esac

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
fi
