#!/bin/bash

# WPI Cloud - tools
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Run WPI Cloud tools scripts
case "${@: -1}" in
  --local | -l) bash ${PWD}/bin/$1/$2.sh "$@";;
  *)            bash <(curl -sL wpi.pw/bin/$1/$2.sh) "$@" && exit 1 ;;
esac
