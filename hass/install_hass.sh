#!/bin/sh
alias apt-yes='sudo DEBIAN_FRONTEND=noninteractive apt-get -y '
apt-yes update
apt-yes upgrade
apt-yes install python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata

sudo useradd -rm homeassistant -G dialout,i2c
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
sudo -u homeassistant -H -s

cd /srv/homeassistant
virtualenv -p /usr/bin/python3 .
source bin/activate
pip install homeassistant

cp hass.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable hass.service

echo "*** First init"
hass
echo "*** First init done"
echo "sudo systemctl start hass.service"
