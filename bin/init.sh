#!/bin/bash

# WPI Cloud - init
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

printf "%s${GRN}Installing:${NC} Make WPI executable\n"
chmod +x wpi
sudo mv wpi /usr/local/bin

printf "%s${GRN}Installing:${NC} wp-cli\n"
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

printf "%s${GRN}Installing:${NC} yq is a lightweight and flexible command-line YAML processor\n"
curl -s -L https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 > yq
chmod +x yq
sudo mv yq /usr/local/bin
