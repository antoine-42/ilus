sudo apt install sudo -y
sudo adduser antoine
sudo usermod -aG sudo antoine
sudo su antoine

sudo apt update && sudo apt upgrade
sudo apt install curl git zsh htop rsync    mdadm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# reboot

sudo mkdir /mnt/storage
lsblk -f
# copy the volume uuid
sudo nano /etc/fstab
# add:
# UUID=<volume uuid>       /mnt/storage    ext4    defaults,auto,nofail    0       2
# https://pve.proxmox.com/wiki/Physical_disk_to_kvm
sudo qm set <VM ID> -scsi<+1> /dev/disk/by-uuid/<volume uuid>
