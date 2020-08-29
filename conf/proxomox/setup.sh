sudo apt install sudo -y
sudo adduser antoine
sudo usermod -aG sudo antoine
sudo su antoine

sudo apt update && sudo apt upgrade
sudo apt install curl git zsh htop rsync    mdadm nut
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# reboot

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
# Edit /etc/udev/rules.d/90-nut-ups.rules to allow the nut user to read from the usb device:
#ACTION=="add", \
#SUBSYSTEM=="usb", \
#ATTR{idVendor}=="0463", ATTR{idProduct}=="ffff", \
#MODE="0660", GROUP="nut"
# Get the idProduct and idVendor with usb-devices.
sudo systemctl restart nut-driver.service nut-server.service

