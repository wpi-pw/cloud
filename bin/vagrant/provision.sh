#!/bin/bash

# WPI Cloud - init
# by Dima Minka (https://dima.mk)
# https://cloud.wpi.pw

# Define custom config if exist
if [[ -f "/vagrant/config.yml" ]]; then
	wpi_conf="/vagrant/config.yml"
fi

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

if [ "$(yq r $wpi_conf vm_box)" == "wpi/box" ]; then
  printf "%s${GRN}Configuring:${NC} email: $(yq r $wpi_conf wpi_email), user:$(yq r $wpi_conf wpi_user)\n"
  sudo echo -e "source ~/.bashrc\n" >> /home/vagrant/.bash_profile 2>/dev/null
  sudo chown vagrant:vagrant /home/vagrant/.[^.]*
  sudo echo -e "[user]\n\tname = $(yq r $wpi_conf wpi_user)\n\temail = $(yq r $wpi_conf wpi_email)" > /home/vagrant/.gitconfig
  sudo echo -e "[user]\n\tname = $(yq r $wpi_conf wpi_user)\n\temail = $(yq r $wpi_conf wpi_user)" > /root/.gitconfig

  printf "%s${GRN}Configuring:${NC} ssh-keyscan for GitHub and BitBucket\n"
  sudo ssh-keyscan -H bitbucket.org >> /home/vagrant/.ssh/known_hosts 2>/dev/null
  sudo ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts 2>/dev/null
  sudo cp -R /home/vagrant/.ssh /root/.ssh 2>/dev/null
  sudo chown vagrant:vagrant /home/vagrant/.ssh/*

  printf "%s${GRN}Preparing:${NC} apps moving to vagrant directory with symlink replacement\n"
  sudo cp -R /var/www/. /vagrant/apps 2>/dev/null
  sudo mv /var/www /var/www-disabled 2>/dev/null
  sudo ln -s /vagrant/apps /var/www 2>/dev/null
  sudo ln -s /vagrant/apps /home/vagrant/apps 2>/dev/null
fi
