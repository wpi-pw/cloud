#!/bin/bash

# WPI Cloud - main script runner
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Get cloud source scripts from github
CLOUD_SOURCE="<(curl -s https://raw.githubusercontent.com/wpi-pw/cloud/master/bin/source.sh)"
# Replace the cloud source path to local on dev flag
[[ "$1" == "dev" ]] && CLOUD_SOURCE="${PWD}/bin/source.sh"
# Load source scripts
source $CLOUD_SOURCE
