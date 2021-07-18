#!/bin/bash

# WPI Cloud - reset
# by DimaMinka (https://dima.mk)
# https://github.com/wpi-pw/app

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color


if [[ -d "wpi-config" ]]; then
  rm -rf .env .env.example .env.old composer.json composer.lock config/ extra/ template-extra/ vendor/ web/ wp-cli.yml wpi-env.yml
  printf "%s${GRN}WPI Reset:${NC} Installed app removed, run wpi-app.sh again.\n"
else
  printf "%s${RED}WPI Reset:${NC} WPI app not found.\n"
fi
