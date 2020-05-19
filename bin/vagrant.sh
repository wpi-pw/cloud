#!/bin/bash

# WPI Cloud - vagrant
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

pwd
bash bin/vagrant/app.sh
exit

if [[ -f "config.yml" ]]; then
  printf "%s${RED}Warning:${NC} Config file exist\n"
  read -r -p "The process will remove Vagrantfile and config! [y/N] " conf_yn
  [[ -z "$conf_yn" || "$conf_yn" =~ ^([nN][oO]|[nN])$ ]] && exit
  # Removing existing files
  rm Vagrantfile config.yml
fi

printf "%s${GRN}Downloading:${NC} WPI Cloud Vagrantfile for local development\n"
curl -sO https://raw.githubusercontent.com/wpi-pw/vagrant/master/Vagrantfile

printf "%s${GRN}Configuration:${NC} Setup Vagrant machine settings\n"
touch config.yml

# Add default machine configuration
yq w -i config.yml  'ip' 192.168.13.100
yq w -i config.yml  'memory' 1024
yq w -i config.yml  'cpus' 1
yq w -i config.yml  'hostname' wpi-box
yq w -i config.yml  'provider' parallels
yq w -i config.yml  'wpi_email' wpi@wpi.pw
yq w -i config.yml  'wpi_user' WPICloud
yq w -i config.yml  'vm_box' wpi/box
yq w -i config.yml  'id_rsa' ~/.ssh/id_rsa
yq w -i config.yml  'id_rsa_pub' ~/.ssh/id_rsa.pub

# Setup Vagrant machine configuration
conf_args=(ip memory cpus hostname provider wpi_email wpi_user vm_box id_rsa id_rsa_pub)
for i in "${!conf_args[@]}"; do
  printf "%s${BLU}${conf_args[$i]}: ${BRN}$(yq r config.yml ${conf_args[$i]})${NC}\n"
  read -r -p "Enter new value to change the ${conf_args[$i]} or ENTER to continue: `echo $'\n> '`" cur_a
  [[ -n "$cur_a" ]] && yq w -i config.yml "${conf_args[$i]}" $cur_a
done

# Run app setup configuration
curl -sL wpi.pw/bin/vagrant/app.sh > vagrant-app && bash vagrant-app && rm vagrant-app

printf "%s${BRN}Completing: ${NC}Please run 'vagrant up' to complete installation\n"