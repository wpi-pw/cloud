#!/bin/bash

# WPI Cloud - help
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

cat ${PWD}/help/help.yml | egrep -v "^\s*(#)"
echo ""