sudo apt install xserver-xorg xinit x11-xserver-utils    chromium-browser matchbox-window-manager xautomation unclutter

sudo cp kiosk.service /usr/lib/systemd/user/
sudo systemctl enable kiosk && sudo systemctl start kiosk
