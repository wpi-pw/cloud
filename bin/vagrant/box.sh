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

# Start to calculate the duration of provision
start_seconds="$(date +%s)"

printf "%s${GRN}Updating:${NC} System update and packages cleanup\n"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
sudo echo grub-pc hold | sudo dpkg --set-selections
sudo add-apt-repository -y ppa:rmescandon/yq > /dev/null 2>&1
sudo apt-get -y update > /dev/null 2>&1
sudo apt-get -y upgrade > /dev/null 2>&1

printf "%s${GRN}Installing:${NC} Install required packages\n"
sudo apt install unzip zip yq jq -y > /dev/null 2>&1

printf "%s${GRN}Setup:${NC} Your username WPICloud, your email is wpi@wpi.pw\n"
sudo echo -e "[user]\n\tname = WPICloud\n\temail = wpi@wpi.pw" > /home/vagrant/.gitconfig
sudo cp /home/vagrant/.gitconfig /root/
sudo chown vagrant:vagrant /home/vagrant/.[^.]*

printf "%s${GRN}Installing:${NC} WordOps init\n"
sudo wget -qO wo wops.cc
sudo bash wo > /dev/null 2>&1 || exit 1

printf "%s${GRN}Downloading:${NC} .profile & .bashrc\n"
sudo wget -qO /var/www/.profile https://raw.githubusercontent.com/wpi-pw/ubuntu-nginx-web-server/master/var/www/.profile
sudo wget -qO /var/www/.bashrc https://raw.githubusercontent.com/wpi-pw/ubuntu-nginx-web-server/master/var/www/.bashrc
sudo cp /home/vagrant/.profile /root
sudo cp /home/vagrant/.bashrc /root

printf "%s${GRN}Setup:${NC} Vagrant alias for WordOps\n"
echo -e "alias wo='sudo -E wo'" >> /home/vagrant/.bashrc
echo -e "source /etc/bash_completion.d/wo_auto.rc" >> /home/vagrant/.bashrc

printf "%s${GRN}Installing:${NC} NGINX, php7.2-7.4 and configure WO backend\n"
sudo wo stack install --php72 --mysql > /dev/null 2>&1 || exit 1
sudo wo stack install --php73 --mysql > /dev/null 2>&1 || exit 1
sudo wo stack install --php74 --mysql > /dev/null 2>&1 || exit 1
sudo yes | sudo wo site create 0.test --php73 --mysql > /dev/null 2>&1
sudo yes | sudo wo site delete 0.test > /dev/null 2>&1

printf "%s${GRN}Installing:${NC} Make WPI executable\n"
wget -qO wpi wpi.pw/wpi
sudo chmod +x wpi
sudo mv wpi /usr/local/bin

printf "%s${GRN}Installing:${NC} Composer and WP CLI\n"
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
sudo mv composer.phar /usr/bin/composer
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

printf "%s${GRN}Cleaning:${NC} Autoremove, apt-get, bash history\n"
sudo apt-get -y autoremove > /dev/null 2>&1
sudo apt-get clean > /dev/null 2>&1
export DEBIAN_FRONTEND=newt
sudo cat /dev/null > ~/.bash_history && history -c

printf "%s${GRN}Tweaking:${NC} Prepare NGINX for local development\n"
sudo sed -i -e "s/sendfile on/sendfile off/g" "/etc/nginx/conf.d/tweaks.conf"
sudo sed -i -e "s/open_file_cache max=50000 inactive=60s/open_file_cache off/g" "/etc/nginx/conf.d/tweaks.conf"

# End to calculate the duration of provision
end_seconds="$(date +%s)"
printf "%s${GRN}Provisioning completed:${NC} in "$(( end_seconds - start_seconds ))" seconds\n"
