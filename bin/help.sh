#!/bin/bash

# WPI Cloud - help
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Run WPI Cloud command
case "${@: -1}" in
  --local | -l) cat ${PWD}/help/$1.yml | egrep -v "^\s*(#)";;
  *)            cat <(curl -s -L wpi.pw/help/$1.yml) | egrep -v "^\s*(#)" && exit 1 ;;
esac
# Styling break line
echo ""
