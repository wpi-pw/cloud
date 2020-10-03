#!/bin/bash

# WPI Cloud - rocket-nginx
# by DimaMinka (https://dima.mk)
# https://github.com/wpi-pw/app

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

printf "%s${GRN}Cloning:${NC} Master branch of Search and Replace to srdb/.\n"
url="https://github.com/interconnectit/Search-Replace-DB.git"
git clone --depth 1 $url --branch master --single-branch srdb --quiet
