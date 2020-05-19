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

  # args helper for config overrides
  case "${app_args[$i]}" in
    host) override=true;;
    repo) override=true;;
    branch) override=true;;
    public_path) override=true;;
    scm) message=true; options=(new github bitbucket);;
    php) message=true; options=(php70 php72 php73 php74);;
    *);;
  esac

  # Git key skipper
  case "${app_args[$i]}-$skip_git" in
    scm-true) continue;;
    repo-true) continue;;
    branch-true) continue;;
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
    [[ "$git_disable" == "new" ]] && skip_git=true
  fi

  # Git sub key helper and skipper
  case "${app_args[$i]}-$cur_a" in
    scm-new) continue;;
    repo-new) continue;;
    branch-new) continue;;
    scm-*) sub_key="git.";;
    repo-*) sub_key="git.";;
    branch-*) sub_key="git.";;
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
