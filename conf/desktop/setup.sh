#!/bin/sh

sudo pacman -Syu
sudo pacman -Rs gwenview kate khelpcenter konversation partitionmanager manjaro-hello okular partitionmanager yakuake
sudo pacman -S apcupsd ark atom chromium dnsutils docker docker-compose dolphin dotnet-sdk ffmpeg filelight firefox gimp git gwe htop illyria-wallpaper jdk-openjdk jdk8-openjdk kde-gtk-config kdeconnect konsole lutris make manjaro-documentation-en materia-gtk-theme nmap noto-fonts noto-fonts-emoji openssh papirus-icon-theme plasma-browser-integration python qbittorrent libreoffice-fresh rclonersync smartmontools spectacle steam-manjaro transmission-remote-gtk tree ttf-fira-code ttf-inconsolata unrar unzip vlc wine wine-gecko wine-mono winetricks youtube-dl zsh
pamac build ckan cnijfilter-mg6200 jetbrains-toolbox mangohud manjaro-printer multimc5 openrgb parsec-bin pinta postman telegraf
sudo systemctl start apcupsd.service
sudo systemctl enable apcupsd.service
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Uncomment/add Color in /etc/pacman.conf for colored output.
# Run `visudo` and append `Defaults env_reset,timestamp_timeout=30` to the file to disable sudo timeout.

git config --global user.email "antoinedujardin42@gmail.com"
git config --global user.name "Antoine Dujardin"
git config --global pull.rebase false
mkdir git && cd git
git clone --recurse-submodules -j8 git@github.com:antoine-42/projects.git