#!/usr/bin/env sh

# Install software
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt update && sudo apt upgrade && sudo apt autoremove
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties telegraf git zsh docker-ce docker-ce-cli containerd.io
sudo usermod -a -G video telegraf

# user stuff
sudo adduser antoine
sudo usermod -aG sudo antoine
sudo su antoine
sudo userdel pi
sudo usermod -aG docker $USER

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
