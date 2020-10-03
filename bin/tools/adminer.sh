#!/bin/bash

# WPI Cloud - adminer
# by DimaMinka (https://dima.mk)
# https://github.com/wpi-pw/app

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

curl -s -o adminer.php -L "http://www.adminer.org/latest-mysql-en.php" \
  && printf "%s${GRN}Success:${NC} Adminer from adminer.org downloaded.\n" \
  || (printf "%s${RED}Error:${NC} Adminer not downloaded.\n" && exit 1)

printf "%s${GRN}Running:${NC} 30 minutes timer for auto deletion.\n"
sleep $((30*60)) && rm "adminer.php" 2>/dev/null &
