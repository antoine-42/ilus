sudo apt install sudo -y
sudo usermod -aG sudo antoine
sudo su antoine

# Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# Docker-compose
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Telegraf
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/os-release
test $VERSION_ID = "7" && echo "deb https://repos.influxdata.com/debian wheezy stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "8" && echo "deb https://repos.influxdata.com/debian jessie stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "9" && echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "10" && echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
# newer kernel
echo "deb http://ftp.debian.org/debian $(lsb_release -cs)-backports main" | sudo tee -a /etc/apt/sources.list > /dev/null


sudo apt update && sudo apt upgrade
sudo apt install curl git zsh htop rsync dnsutils smartmontools lm-sensors qemu-guest-agent    apt-transport-https ca-certificates gnupg-agent software-properties-common    docker-ce docker-ce-cli containerd.io    telegraf
sudo apt install linux-image-<latest version>

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo usermod -aG docker $USER

# Clone projects
mkdir ~/git
cd ~/git
git clone --recurse-submodules -j8 git@github.com:antoine-42/projects.git

# Setup RAID
lsblk -f
# copy the volume uuid
sudo nano /etc/fstab
# add
# UUID=<volume uuid>       /mnt/storage    ext4 defaults,auto      0       2
sudo cp ~/git/projects/ilus/conf/debian/telegraf/* /etc/telegraf/
sudo systemctl restart telegraf

# NUT
#todo

# Secondary IP adress
# Add to /etc/network/interfaces:
#iface <interface> inet dhcp
#    up   ip addr add <ip>/<mask> dev <interface>
#    down ip addr del <same ip>/<same mask> dev <interface>
# For example:
#iface ens18 inet dhcp
#    up   ip addr add 192.168.0.25/24 dev ens18
#    down ip addr del 192.168.0.25/24 dev ens18
