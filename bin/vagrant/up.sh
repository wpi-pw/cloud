#!/bin/bash

# WPI UP - for every vagrant up provision
# by DimaMinka (https://dima.mk)
# https://github.com/wpi-pw/app

# Define colors
readonly RED='\033[0;31m' # error
readonly GRN='\033[0;32m' # success
readonly BLU='\033[0;34m' # task
readonly BRN='\033[0;33m' # headline
readonly NC='\033[0m'     # no color

# Define custom config if exist
if [[ -f "/vagrant/config.yml" ]]; then
	wpi_conf="/vagrant/config.yml"
fi

printf "%s${GRN}Staring:${NC} NGINX running after app folder sync\n"
# Start NGINX on vagrant up - not started automatically with symlink to WebRoot WWW
sudo service nginx start

printf "%s${GRN}Checking:${NC} Read config for new apps\n"
# Create array of app hosts and loop
mapfile -t apps_host < <( yq r $wpi_conf 'apps.[*].host' )
# App create, disable, enable
for i in "${!apps_host[@]}"
do
  if [ "$(yq r $wpi_conf apps.[$i].status)" == "disable" ] || [ "$(yq r $wpi_conf apps.[$i].status)" == "enable" ]; then
    printf "%s${BLU}$(yq r $wpi_conf apps.[$i].status):${NC} ${apps_host[$i]}\n"
    # Enable/Disable app via WordOps
    yes | sudo wo site $(yq r $wpi_conf apps.[$i].status) ${apps_host[$i]} --quiet
    # Change app status to enabled/disabled
    yq w -i $wpi_conf apps.[$i].status "$(yq r $wpi_conf apps.[$i].status)d"
    printf "%s${GRN}##############################${NC}\n"
  fi

  if [ "$(yq r $wpi_conf apps.[$i].status)" == "create" ]; then
    printf "%s${BLU}Creating:${NC} ${apps_host[$i]}\n"
    # Create app via WordOps
    yes | sudo wo site create ${apps_host[$i]} --mysql --$(yq r $wpi_conf apps.[$i].php) --quiet
    # Change app status to created
    yq w -i $wpi_conf apps.[$i].status "$(yq r $wpi_conf apps.[$i].status)d"
    # GIT pull via github/bitbucket
    if [ "$(yq r $wpi_conf apps.[$i].git.scm)" == "github" ] || [ "$(yq r $wpi_conf apps.[$i].git.scm)" == "bitbucket" ]; then
      printf "%s${GRN}Cloning:${NC} $(yq r $wpi_conf apps.[$i].git.repo)\n"
      if [ "$(yq r $wpi_conf apps.[$i].git.scm)" == "github" ]; then
        scm="github.com"
      else
        scm="bitbucket.org"
      fi
      rm -rf /vagrant/apps/${apps_host[$i]}/htdocs
      cd /vagrant/apps/${apps_host[$i]}
      git clone --single-branch --branch $(yq r $wpi_conf apps.[$i].git.branch) --depth=1 --quiet git@$scm:$(yq r $wpi_conf apps.[$i].git.repo).git htdocs 2>/dev/null
    fi
    # Public path changing in nginx conf via config
    if [ ! -z "$(yq r $wpi_conf apps.[$i].public_path)" ]; then
      printf "%s${GRN}Configuring:${NC} Public dir changing to $(yq r $wpi_conf apps.[$i].public_path)\n"
      new_path=$(echo "$(yq r $wpi_conf apps.[$i].public_path)" | sed 's/\//\\\//g')
      sudo sed -i -e "s/htdocs/$new_path/g" "/etc/nginx/sites-available/${apps_host[$i]}"
      sudo service nginx reload
    fi
    printf "${GRN}##############################${NC}\n"
  fi
done

printf "%s${BRN}Showing apps list:${NC}\n"
sudo wo site list
