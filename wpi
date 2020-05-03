#!/bin/bash

# WPI Cloud - main script runner
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

if [[ "$1" == "dev" ]]; then
  # Load local source scripts on dev flag
  source ${PWD}/bin/source.sh
else
  # Load cloud source scripts from github
  source <(curl -s https://raw.githubusercontent.com/wpi-pw/cloud/master/bin/source.sh)
fi
