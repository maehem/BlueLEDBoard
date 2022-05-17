#!/usr/bin/env bash
#One time install the blueled system
#can also be run non-destrucively to update executables
#must be run with sudo

# 2022-01 - by Mark Koch.
# Removed Drop Box support and added USB stick support.
#


# USB Stick Mounting for autodetect of the USB thumb drive
#
# use:  sudo apt install usbmount
#
# Also: Update the system setting to allow  autodetect of USB drive.
# Therefor if you want to make usbmount work again, the already given configuration syntax is right. But you should place it like this.
#
# Create a configuration container directory /etc/systemd/system/systemd-udevd.service.d.
#
# sudo mkdir /etc/systemd/system/systemd-udevd.service.d
# Create an own confugration file (that will overwrite the package configuration). Change 00-my-custom-mountflags as you wish.
#
# sudo nano -w /etc/systemd/system/systemd-udevd.service.d/00-my-custom-mountflags.conf
# Enter the following configuration, which disables private mounts.
#
# [Service]
# PrivateMounts=no
# Restart systemd and udev subprocesses (or simply reboot).
#
# Files will appear in /media/usb0 under messages directory
# there should also be an empty file called 'blueled'

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#Stop any running instances to clear access to the files
sudo systemctl stop blueled.service
# We don't use DropBox anymore.
# There are defaullt messages which get over-ridden by a USB stick
# and reverted when the stick is removed.
#sudo systemctl stop grabdropbox.timer


#build the executable
make
# Damn, I've read like 10 articles about where I *should* put the exeutable and cant figure out if this is right. Really linux?
cp blueled /usr/local/bin

chmod +x *.sh

cp blueled*.sh /usr/local/bin
cp checkusbstick.sh /usr/local/bin
# No more Drop Box
#cp grabdropbox.sh /usr/local/bin

if [ ! -e /etc/blueled ]; then
  mkdir /etc/blueled
fi

# Old default.  Depricated.
if [ ! -e /etc/blueled/defaultmessage.txt ]; then
    cp defaultmessage.txt /etc/blueled/
fi
# New Default
if [ ! -e /etc/blueled/messages ]; then
    cp -r messages /etc/blueled/
fi

if [ ! -e /etc/blueled/defaultfont.txt ]; then
    cp defaultfont.txt /etc/blueled/
fi

#copy the serive unit files to the right place
sudo cp blueled.service $(pkg-config systemd --variable=systemdsystemunitdir)
sudo cp checkusbstick.service $(pkg-config systemd --variable=systemdsystemunitdir)
sudo cp checkusbstick.timer $(pkg-config systemd --variable=systemdsystemunitdir)
#sudo cp grabdropbox.service $(pkg-config systemd --variable=systemdsystemunitdir)
#sudo cp grabdropbox.timer $(pkg-config systemd --variable=systemdsystemunitdir)

#force a reload in case we are overwriting existing files with new versions
sudo systemctl daemon-reload

#set the service to run on boot
sudo systemctl enable blueled.service
sudo systemctl enable checkusbstick.timer
#sudo systemctl enable grabdropbox.timer


if [ ! -e /etc/blueled/portlist ]; then
   # Assumes all ports are in /dev/ttyUSB?. Might not be true if you are using different hardware than the normal USB serial ocypuses.
   for f in /dev/ttyUSB?; do
       basename $f >>/etc/blueled/portlist
   done
   echo "Please edit /etc/blueled/portlist and make sure it has the correct ports for actual attached controller boards"
   echo "then reboot or re-run install..."
fi

sudo systemctl start blueled.service
sudo systemctl start checkusbstick.timer
#sudo systemctl start grabdropbox.timer
