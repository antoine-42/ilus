#!/bin/sh

# Based on https://pimylifeup.com/raspberry-pi-kiosk/

KIOSK_SETUP_PATH="/home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk"

# Install dependencies
sudo apt install xserver-xorg xinit lightdm    chromium-browser matchbox-window-manager xautomation unclutter upower libgles2

# Copy the service file
sudo cp $KIOSK_SETUP_PATH/kiosk.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable kiosk && sudo systemctl start kiosk

# Always autoselect the first valid certificate
sudo mkdir /etc/chromium-browser/policies
sudo mkdir /etc/chromium-browser/policies/managed
echo "{\"AutoSelectCertificateForUrls\": [\"{\\\"pattern\\\":\\\"*\\\",\\\"filter\\\":{}}\"]}" | sudo tee /etc/chromium-browser/policies/managed/AutoSelectCertificateForUrls.json

# Install grafana-kiosk
wget https://github.com/grafana/grafana-kiosk/releases/download/v1.0.2/grafana-kiosk.linux.armv7 -O /tmp/grafana-kiosk.linux.armv7
sudo cp /tmp/grafana-kiosk.linux.armv7 /usr/bin/grafana-kiosk
sudo chmod 755 /usr/bin/grafana-kiosk

# Fill in grafana-kiosk login info
cp $KIOSK_SETUP_PATH/template-grafana-kiosk.yml $KIOSK_SETUP_PATH/grafana-kiosk.yaml
chmod 600 $KIOSK_SETUP_PATH/grafana-kiosk.yaml
nano $KIOSK_SETUP_PATH/grafana-kiosk.yaml

# Import certificate to chrome manually
chromium-browser --display=:0
