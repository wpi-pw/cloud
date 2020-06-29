#!/bin/bash

# WPI Theme Release
# by DimaMinka (https://dima.mk)
# https://github.com/wpi-pw/app

# Get config files and put to array
wpi_confs=()
for ymls in wpi-config/*
do
  wpi_confs+=("$ymls")
done

# Get wpi-source for yml parsing, noroot, errors etc
source <(curl -s https://raw.githubusercontent.com/wpi-pw/template-workflow/master/wpi-source.sh)

cur_env=$(cur_env)

# Create array of theme symlinks and loop
mapfile -t symlinks < <( wpi_yq 'themes.parent.symlink.[*].env' )
# Get all symlink env and run the script for the current
for i in "${!symlinks[@]}"
do
  # Copy current release of theme
  if [[ "$(wpi_yq themes.parent.symlink.[$i].env)" == "$cur_env" ]]; then
    app_dir=${PWD}
    app_content=$( wpi_yq "env.$cur_env.app_content" )
    theme_name=$(echo $( wpi_yq "themes.parent.name" ) | cut -d"/" -f2)
    theme_path="${app_dir%/}${app_content%/}/themes/$theme_name"
    theme_symlink=$( wpi_yq "themes.parent.symlink.[$i].path" )
    if [[ -d "$theme_symlink" ]]; then
      printf "${GRN}====================================================${NC}\n"
      printf "${GRN}Copy current release of $theme_name                 ${NC}\n"
      printf "${GRN}====================================================${NC}\n"
      rsync -rvq --exclude=node_modules "$theme_symlink/" "$theme_path-tmp"
      rm -rf $theme_path
      mv "$theme_path-tmp" $theme_path
    fi
  fi
done
