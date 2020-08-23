sudo apt install sudo -y
sudo usermod -aG sudo antoine
sudo su antoine

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo apt update && sudo apt upgrade
sudo apt install curl git zsh smartmontools lm-sensors    apt-transport-https ca-certificates gnupg-agent software-properties-common    docker-ce docker-ce-cli containerd.io

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo usermod -aG docker $USER

mkdir git
cd git
git clone --recurse-submodules -j8 git@github.com:antoine-42/projects.git
