# Based on https://pimylifeup.com/raspberry-pi-kiosk/

sudo apt install xserver-xorg xinit x11-xserver-utils lightdm    chromium-browser matchbox-window-manager xautomation unclutter upower libgles2

sudo cp kiosk.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable kiosk && sudo systemctl start kiosk

# Import certificate to chrome

# Always autoselect the first valid certificate
sudo mkdir /etc/chromium-browser/policies
sudo mkdir /etc/chromium-browser/policies/managed
echo "{\"AutoSelectCertificateForUrls\": [\"{\\\"pattern\\\":\\\"*\\\",\\\"filter\\\":{}}\"]}" | sudo tee /etc/chromium-browser/policies/managed/AutoSelectCertificateForUrls.json

# Install grafana-kiosk
wget https://github.com/grafana/grafana-kiosk/releases/download/v1.0.2/grafana-kiosk.linux.armv7 -O /tmp/grafana-kiosk.linux.armv7
sudo cp /tmp/grafana-kiosk.linux.armv7 /usr/bin/grafana-kiosk
sudo chmod 755 /usr/bin/grafana-kiosk

# Fill in grafana-kiosk login info
cp /home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk/template-grafana-kiosk.yml /home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk/grafana-kiosk.yaml
chmod 600 /home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk/grafana-kiosk.yaml
nano /home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk/grafana-kiosk.yaml
