#!/bin/sh
# Install samba on new PC
# https://askubuntu.com/questions/536977/create-a-user-for-samba-only-cli
#
# Setup
# -----
SMUSER=datadrive
SMGRP=linaro
HOSTN=`cat /etc/hostname`

# Install samba
alias apt-yes='sudo DEBIAN_FRONTEND=noninteractive apt-get -y '
apt-yes install samba

# add unix user for samba
echo "*** Adding unix user for samba"
sudo adduser --no-create-home --disabled-password --disabled-login $SMUSER
sudo usermod -g $SMGRP $SMUSER

echo "*** Adding password for samba use"
sudo smbpasswd -a $SMUSER

# configuring share
sudo mv -f /etc/samba/smb.conf /etc/samba/smb.conf.orig
sudo perl -pe "s/netbios name = .*/netbios name = $HOSTN/" /nas/db_scripts/smb.conf > ~/smb.conf
sudo mv -f ~/smb.conf /etc/samba/smb.conf

sudo systemctl restart smbd

