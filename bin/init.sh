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
mv wpi /usr/local/bin

printf "%s${GRN}Installing:${NC} wp-cli\n"
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

printf "%s${GRN}Installing:${NC} yq/jq is a lightweight and flexible command-line YAML/JSON processor\n"
sudo echo grub-pc hold | sudo dpkg --set-selections
sudo add-apt-repository -y ppa:rmescandon/yq > /dev/null 2>&1
sudo apt-get -y update > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null 2>&1
sudo apt install yq jq -y > /dev/null 2>&1
