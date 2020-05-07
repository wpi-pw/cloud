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
  app | init | help);;
  *)  printf "${RED}Warning:${NC} '%s' is not a registered wpi command. See 'wpi help'. \n" "$1" && exit 1 ;;
esac

# Get and prepare args and flags for help docs reading
for i in "$@"; do
  case "$i" in
    --help | -h)  HELP=true;;                   # Enable help docs
    --local | -l) LOCAL=true;;                  # Enable local loading
    help)         HELP=true; HELP_PATH+="/$i";; # Enable main help docs
    *)            HELP_PATH+="/$i";;            # Build help file path
  esac
done

# Read help docs if help command running
if [[ -n "$HELP" ]]; then
  [[ -z "$LOCAL" ]] && CAT_PATH="cat <(curl -s -L wpi.pw/help$HELP_PATH.yml)" # Read docs from cloud
  [[ -n "$LOCAL" ]] && CAT_PATH="cat ${PWD}/help$HELP_PATH.yml"               # Read docs from local
  eval $CAT_PATH | egrep -v "^\s*(#)" | more -d
  exit 1
fi

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
fi
