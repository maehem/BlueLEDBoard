#!/usr/bin/env bash
# This script will start up a single instance of the LED master
# controller pointing to the specified device.
#
# note: only pass the device name and not the /dev directory
#
# Typically called from blueledrunall.sh
#
# Kill any previously running instance on that device
# Note that it seems like I should be using /var for all this stuff,
# but then this file would not work when run by non-root.
if [ -e /tmp/blueled/$1/pid ]; then
  echo killing $(cat /tmp/blueled/$1/pid)
  kill $(cat /tmp/blueled/$1/pid)
fi

if [ ! -e /tmp/blueled ]; then
    mkdir /tmp/blueled
fi

# Font might have already been copied by a previous instance.
if [ ! -e /tmp/blueled/font.txt ]; then
    cp /etc/blueled/defaultfont.txt /tmp/blueled/font.txt
fi

# Make a dir for our ttyUSBn port.
if [ ! -e /tmp/blueled/$1 ]; then
    mkdir /tmp/blueled/$1
fi

# Old message set up.
#if [ ! -e /tmp/blueled/$1/message.txt ]; then
#    cp /etc/blueled/defaultmessage.txt /tmp/blueled/$1/message.txt
#fi
# New message set up.
if [ ! -e /tmp/blueled/$1/message.txt ]; then
    cp /etc/blueled/messages/$1.txt /tmp/blueled/$1/message.txt
fi

# The USB device must be the proper baud rate ( 1MHz ).
stty -F /dev/$1 1000000 raw clocal -hupcl -echo
# 'blueled' displays the message then reloads the message file.  This
# way you can change the contents of /tmp/blueled/ttyUSBn/message.text
# and it will display the latest file contents. The USB stick service
# updates the message file once a minute.
blueled /dev/$1  /tmp/blueled/$1/message.txt /tmp/blueled/font.txt &
echo $! >/tmp/blueled/$1/pid
