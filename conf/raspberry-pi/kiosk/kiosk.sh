#!/bin/sh

# Based on https://pimylifeup.com/raspberry-pi-kiosk/

xset -dpms     # disable DPMS (Energy Star) features.
xset s off     # disable screen saver
xset s noblank # don't blank the video device
matchbox-window-manager -use_titlebar no &
unclutter &    # hide X mouse cursor unless mouse activated
grafana-kiosk -c /home/antoine/git/projects/ilus/conf/raspberry-pi/kiosk/grafana-kiosk.yaml
