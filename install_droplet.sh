#! /bin/sh
###############################################################
# Installation notes for dragon board
# Known working on linaro release: 21.12
#
# Prequisities:
# delete using partition tool sdcard
# search partition in windows
# create a new exfat with quick format
#
# Handle partitions
# sudo fdisk [-l for view]
# Format the sdcard:
# sudo mkfs.ext4 /dev/mmcblk1p1
# sudo mount -t ext4 -o rw /dev/mmcblk1p1 /media/linaro/sdcard
#### INFO ####
# This is a two stage installation!
# Usage:
# ./install init
# sudo reboot
# ./install
#### INFO ####
#
###############################################################
# First stage (before reboot)
# Memory card is with exfat:
# Need to apt-get pkt else no root login will happen on boot
if [ "$1" = "init" ]; then
        # tweak system
        echo "*** tweak system"
	sudo mkdir -p /media/linaro/sdcard
        sudo sh -c 'echo /dev/mmcblk1p1 /media/linaro/sdcard ext4 rw 0 2 >> /etc/fstab'
	sudo mount -a
	sudo chown linaro:linaro -R /media/linaro/sdcard
        sudo ln -fs /media/linaro/sdcard /datadrive
        sudo ln -fs /home/linaro /nas
        exit
fi
###############################################################
# Second stage (after reboot)
alias apt-yes='sudo DEBIAN_FRONTEND=noninteractive apt-get -y '


########### Manual steps ###########
echo "*** Please change password"
passwd
echo "*** Please enter hostname: g.e. iot_hub, pegion"
read HOSTREAD
sudo sh -c "echo $HOSTREAD > /etc/hostname"
sudo perl -pe "s/127.0.1.1.*/127.0.1.1       $HOSTREAD/" /etc/hosts > /etc/hosts.bak
sudo mv /etc/hosts.bak /etc/hosts
sudo hostname $HOSTREAD
#mv -f /nas/settings/smb.conf /nas/settings/smb.conf.bak
#sudo perl -pe "s/netbios name = .*/netbios name = $HOSTREAD/" /nas/settings/smb.conf.bak > /nas/settings/smb.conf 

########### script #################

# refresh repositories
echo "*** Updating OS first"
apt-yes update
apt-yes upgrade
apt-yes dist-upgrade
sudo apt autoremove

# Remove gui
sudo systemctl set-default multi-user.target

# install apps
git clone https://github.com/idanre1/settings.git
git clone https://github.com/idanre1/scripts.git

#Making nice linux
sudo ln -s ~ /nas
sudo ln -s /home/$USER /home/idan

# set timezone
sudo timedatectl set-timezone Asia/Jerusalem

# easy linux
aptyes install source-highlight curl libsnappy-dev
echo source ~/settings/bashrc >> ~/.bashrc
echo source ~/settings/vimrc >> ~/.vimrc
sudo sh -c "echo 'set background=dark' >> /root/.vimrc"

# -----------------------------------------
# Python3
# -----------------------------------------
mkdir -p ~/Envs
aptyes install python3 python3-pip python3-tk virtualenv
# virtualenv -p /usr/bin/python3 --no-site-packages ~/py3env
virtualenv -p /usr/bin/python3 ~/Envs/py3env

# default pyhton env init
source ~/settings/python_init.sh
cd $py3bin
source activate
pip -V
deactivate

# Allow for user libs (must come after a single pip install)
PYVER=`ls -1 ~/Envs/py3env/lib/ | grep "python" | head -1`
ln -s /nas/settings/site-packages.pth /nas/Envs/py3env/lib/$PYVER/site-packages/site-packages.pth

# END
echo "*** Install is done. please restart the system"
