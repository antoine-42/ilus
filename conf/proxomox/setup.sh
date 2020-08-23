sudo apt install sudo -y
sudo adduser antoine
sudo usermod -aG sudo antoine
sudo su antoine

sudo apt update && sudo apt upgrade
sudo apt install curl git zsh htop    mdadm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# reboot

sudo mkdir /mnt/storage
lsblk -f
# copy the volume id
sudo nano /etc/fstab
# add:
# UUID=<volume id>       /mnt/storage    ext4    defaults,auto,nofail    0       2
