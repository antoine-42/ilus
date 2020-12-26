sudo apt install sudo -y
sudo adduser antoine
sudo usermod -aG sudo antoine
sudo su antoine

# Update the apt repositories https://pve.proxmox.com/wiki/Package_Repositories

# Telegraf
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/os-release
test $VERSION_ID = "7" && echo "deb https://repos.influxdata.com/debian wheezy stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "8" && echo "deb https://repos.influxdata.com/debian jessie stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "9" && echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
test $VERSION_ID = "10" && echo "deb https://repos.influxdata.com/debian buster stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

# Install packages
sudo apt update && sudo apt upgrade && sudo apt autoremove
sudo apt install curl git zsh htop rsync    mdadm nut smartmontools telegraf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone projects
mkdir ~/git
cd ~/git
mkdir projects
cd projects
git config --global user.email "antoinedujardin42@gmail.com"
git config --global user.name "Antoine Dujardin"
git clone --recurse-submodules -j8 git@github.com:antoine-42/ilus.git

# reboot now
shutdown -r

# Raid setup
sudo mkdir /mnt/storage
lsblk -f
# copy the volume uuid
sudo nano /etc/fstab
# add:
# UUID=<volume uuid>       /mnt/storage    ext4    defaults,auto,nofail    0       2
# https://pve.proxmox.com/wiki/Physical_disk_to_kvm
sudo qm set <VM ID> -scsi<+1> /dev/disk/by-uuid/<volume uuid>

# NUT setup
# Set MODE in /etc/nut/nut.conf:
#MODE=netserver
# Add to `/etc/nut/ups.conf`:
#[eaton-ellipse-eco-650]
#    driver = usbhid-ups  # https://networkupstools.org/stable-hcl.html
#    port = auto
#    desc = "Eaton Ellipse ECO 650"
# Set MAXAGE, and LISTEN in /etc/nut/upsd.conf.
#MAXAGE 15
#LISTEN 0.0.0.0 3493
#LISTEN :: 3493
# Set users in /etc/nut/upsd.users:
#[monitor]
#    password = <normal password>
#    upsmon slave
#
#[admin]
#    password = <strong password, this allows remote shutdown>
#    upsmon master
#    actions = SET
#    instcmds = ALL
#
# Add to /etc/nut/upsmon.conf:
#MONITOR eaton-ellipse-eco-650@localhost 1 <account> <account password> master
# Edit /etc/udev/rules.d/90-nut-ups.rules to allow the nut user to read from the usb device:
#ACTION=="add", \
#SUBSYSTEM=="usb", \
#ATTR{idVendor}=="0463", ATTR{idProduct}=="ffff", \
#MODE="0660", GROUP="nut"
# Get the idProduct and idVendor with usb-devices.
sudo systemctl restart nut-driver.service nut-server.service nut-monitor.service

