#!/bin/sh

sudo pacman -Syu
sudo pacman -Rs gwenview kate khelpcenter konversation partitionmanager manjaro-hello okular partitionmanager yakuake
sudo pacman -S \
  ark chromium dolphin filelight firefox konsole lutris spectacle steam-manjaro \
  gimp qbittorrent libreoffice-fresh transmission-remote-gtk vlc \
  ffmpeg htop smartmontools spectacle tree unrar unzip youtube-dl zsh \
  atom dnsutils git make nmap rclonersync \
  gwe kdeconnect plasma-browser-integration \
  kde-gtk-config materia-gtk-theme noto-fonts noto-fonts-emoji papirus-icon-theme ttf-fira-code ttf-inconsolata \
  apcupsd \
  openssh \
  docker docker-compose \
  dotnet-sdk jdk-openjdk jdk8-openjdk python python-pip python-setuptools \
  wine wine-gecko wine-mono winetricks \
  libffi arm-none-eabi-gcc avr-gcc dfu-util avrdude dfu-programmer
pamac build \
  ckan mangohud multimc5 openrgb parsec-bin \
  cnijfilter-mg6200 manjaro-printer \
  pinta \
  telegraf \
  jetbrains-toolbox postman
sudo systemctl start apcupsd.service
sudo systemctl enable apcupsd.service
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

python3 -m pip install --user qmk
qmk setup

# Install kernel headers for all kernels
sudo pacman -S $(pacman -Qsq "^linux" | grep "^linux[0-9]*[-rt]*$" | awk '{print $1"-headers"}' ORS=' ')

# Uncomment/add Color in /etc/pacman.conf for colored output.
# Run `visudo` and append `Defaults env_reset,timestamp_timeout=30` to the file to disable sudo timeout.

git config --global user.email "antoinedujardin42@gmail.com"
git config --global user.name "Antoine Dujardin"
git config --global pull.rebase false
mkdir git && cd git
git clone --recurse-submodules -j8 git@github.com:antoine-42/projects.git

echo "include /usr/share/nano/*.nanorc" > ~/.nanorc
