#!/bin/bash

# WPI Cloud - tools
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Check for a registered commands
case "$2" in
  adminer | rocket-nginx | srdb | wpi-reset);;
  *)  printf "${RED}Warning:${NC} '%s' is not a registered wpi command. See 'wpi tools --help'. \n" "$1 $2" && exit 1 ;;
esac

# Run WPI Cloud tools scripts
case "${@: -1}" in
  --local | -l) bash ${PWD}/bin/$1/$2.sh "$@";;
  *)            bash <(curl -sL wpi.pw/bin/$1/$2.sh) "$@" && exit 1 ;;
esac
