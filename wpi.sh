#!/bin/bash

# WPI Cloud - main script runner
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Check for current operation system and runner for macOS local vagrant development
case "$(uname -s)-$1-$2" in
    Linux-*-*);;
    Darwin-vagrant-) curl -sL wpi.pw/bin/$1.sh > $1 && bash $1 && rm $1 && exit 1;;
    Darwin-vagrant-app) curl -sL wpi.pw/bin/$1/$2.sh > $1-$2 && bash $1-$2 && rm $1-$2 && exit 1;;
    *)              echo "WPI Cloud supported only Linux OS" && exit 1
esac

# Load cloud source scripts
case "${@: -1}" in
  --local | -l) source ${PWD}/bin/source.sh;; # Load local source scripts
  *)            source <(curl -s https://raw.githubusercontent.com/wpi-pw/cloud/master/bin/source.sh);;
esac

# Run WPI Cloud command
case "${@: -1}" in
  --local | -l) bash ${PWD}/bin/$1.sh "$@";;
  *)            bash <(curl -sL wpi.pw/bin/$1.sh) "$@" && exit 1 ;;
esac
