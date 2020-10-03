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

printf "%s${GRN}Cloning:${NC} Master branch of Rocket Nginx.\n"
git clone https://github.com/wpi-pw/rocket-nginx.git /etc/nginx-rc/rocket-nginx --quiet
printf "%s${GRN}Running:${NC} Copy .ini and parse the config.\n"
cp /etc/nginx-rc/rocket-nginx/rocket-nginx.ini.disabled /etc/nginx-rc/rocket-nginx/rocket-nginx.ini
cd /etc/nginx-rc/rocket-nginx
php /etc/nginx-rc/rocket-nginx/rocket-parser.php
cd ~/
