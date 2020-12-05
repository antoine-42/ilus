sudo adduser antoine
sudo usermod -aG adm antoine
sudo usermod -aG wheel antoine
sudo usermod -aG systemd-journal antoine
sudo su antoine
passwd
ssh-keygen

# Install Software
sudo yum update && sudo yum upgrade
sudo yum install git zsh htop youtube-dl
# Docker: https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2
# Docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Telegraf: https://docs.influxdata.com/telegraf/v1.16/introduction/installation/


# Clone projects
mkdir ~/git
cd ~/git
git config --global user.email "antoinedujardin42@gmail.com"
git config --global user.name "Antoine Dujardin"
git clone --recurse-submodules -j8 git@github.com:antoine-42/projects.git

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

