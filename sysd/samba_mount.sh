#!/bin/sh

echo "starting usb mount"
sudo mount -o uid=pi,gid=pi /dev/sda1 /mnt/usbstore/book

sudo service smbd restart
sudo service nmbd restart