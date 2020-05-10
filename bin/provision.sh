#!/usr/bin/env bash

echo "=============================="
echo "System update and packages cleanup"
echo "=============================="
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
sudo echo grub-pc hold | sudo dpkg --set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

echo "=============================="
echo "Install useful packages"
echo "=============================="
sudo apt install haveged curl git unzip zip -y

echo "=============================="
echo "Your username WordOps, your email is test@test.test"
echo "=============================="
sudo chown vagrant:vagrant /home/vagrant/.[^.]*
sudo echo -e "[user]\n\tname = WordOps\n\temail = test@test.test" > ~/.gitconfig

echo "=============================="
echo "Install WordOps"
echo "=============================="
sudo wget -qO wo wops.cc
sudo bash wo || exit 1

echo "=============================="
echo "Install Nginx, php7.3 and configure WO backend"
echo "=============================="
sudo wo stack install --mysql --php73 || exit 1
sudo yes | sudo wo site create 0.test --php73 --mysql
sudo echo -e "[user]\n\tname = WordOps\n\temail = test@test.test" > ~/.gitconfig
sudo yes | sudo wo site delete 0.test

echo "=============================="
echo "Install Composer"
echo "=============================="
cd ~/
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

echo "=============================="
echo "Allow shell for www-data for SFTP usage"
echo "=============================="
sudo usermod -s /bin/bash www-data

echo "=============================="
echo "wp cli - ianstall and add bash-completion for user www-data"
echo "=============================="
# automatically generate the security keys
wp package install aaemnnosttv/wp-cli-dotenv-command --allow-root
# download wp-cli bash_completion
sudo wget -O /etc/bash_completion.d/wp-completion.bash https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash
# change /var/www owner
sudo chown www-data:www-data /var/www
# download .profile & .bashrc for www-data
sudo wget -O /var/www/.profile https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/var/www/.profile
sudo wget -O /var/www/.bashrc https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/var/www/.bashrc

# set owner
sudo chown www-data:www-data /var/www/.profile
sudo chown www-data:www-data /var/www/.bashrc

# add wo for non-root users 
echo -e "alias wo='sudo -E wo'" >> /home/vagrant/.bashrc
echo -e "source /etc/bash_completion.d/wo_auto.rc" >> /home/vagrant/.bashrc
# copy .profile/.bashrc to root
sudo cp /home/vagrant/.profile /root
sudo cp /home/vagrant/.bashrc /root

echo "=============================="
echo "Downloading: yq is a lightweight and flexible command-line YAML processor"
echo "=============================="
sudo add-apt-repository ppa:rmescandon/yq
sudo apt update
sudo apt install yq -y

echo "=============================="
echo "Downloading: search-replace-database installer - srdb.sh"
echo "=============================="
cd /usr/local/bin && sudo wget https://gist.githubusercontent.com/DimaMinka/24c3df57a78dd841a534666a233492a9/raw/d5ca7209164c7a22879fc7863f1bac1f0145ba84/srdb.sh
sudo chmod +x srdb.sh

echo "=============================="
echo "Clean before package"
echo "=============================="
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
sudo apt-get -y autoremove && sudo apt-get clean
export DEBIAN_FRONTEND=newt
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
sudo cat /dev/null > ~/.bash_history && history -c
