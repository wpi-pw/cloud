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

printf "%s${GRN}Configuration:${NC} Setup the app\n"

# Setup app
def_args=(wpi.test create new wpi-pw/app master php73 htdocs/web)
app_args=(host status scm repo branch php public_path)
apps_index="$(yq r config.yml --length apps)"
for i in "${!app_args[@]}"; do
  cur_a=""
  cur_option=""
  message=""
  options=()
  override=""
  sub_key=""

  case "${app_args[$i]}" in
    host) override=true;;
    repo) override=true;;
    branch) override=true;;
    public_path) override=true;;
    scm) message=true; options=(new github bitbucket);;
    php) message=true; options=(php70 php72 php73 php74);;
    *);;
  esac

  if [[ -n "$override" ]]; then
    # Override default app values
    read -r -p "Enter new value to change the ${app_args[$i]} or ENTER for default: `echo $'\n> '`" cur_a
  fi

  # Default app details if new not exist
  [[ -z "$cur_a" ]] && cur_a=${def_args[$i]}

  # Set the value from options list
  if [[ -n "$message" ]]; then
    # Gat options list
    for o in "${!options[@]}"; do
      echo "[$((o+1))] ${options[$o]}"
    done
    # Check if value exist in the options list
    while [[ ! ${cur_option} =~ ^[0-9]+$ ]]; do
        read -n 1 -ep "Choose the value for ${app_args[$i]} from the list: " cur_option
        ! [[ ${cur_option} -ge 1 && ${cur_option} -le ${#options[@]}  ]] && unset cur_option
    done
    # Set value to current variable
    cur_a=${options[$((cur_option-1))]}
    git_disable=$cur_a
  fi

  # Git sub key helper
  case "${app_args[$i]}-$git_disable" in
    scm-) sub_key="git.";;
    repo-) sub_key="git.";;
    branch-) sub_key="git.";;
    scm-new) continue;;
    repo-new) continue;;
    branch-new) continue;;
    *);;
  esac

  # Index helper for multi apps
  [[ -z "$apps_index" ]] && apps_index="0"

  # Current config key
  cur_key="apps.[$apps_index].$sub_key${app_args[$i]}"
  # Write data to config
  yq w -i config.yml "$cur_key" $cur_a
  printf "%s${BLU}${app_args[$i]}: ${BRN}$cur_a${NC}\n"

done

printf "%s${GRN}Displaying: ${NC}Apps list:\n"
yq r config.yml -C apps

printf "%s${BRN}Completing: ${NC}Please run 'vagrant up' to complete installation\n"