#!/bin/bash
#

sudo apt-get remove --purge samba samba-common-bin -y
sudo apt-get install samba samba-common-bin -y

sudo hostnamectl set-hostname booka

sudo ./home/pi/blink1/commandline/blink1-tool --red
echo "all ready to go"

#Mount USB drive 
sudo mkdir /mnt/usb/book
sudo mount -o uid=pi,gid=pi /dev/sda1 /mnt/usb/book
echo "drive mounted"

#setup samba share
sudo chown -R pi:pi /mnt/usb/book
sudo cp /etc/samba/smb.conf /etc/samba/smb.bak
cat > /etc/samba/smb.conf<<EOF
wins support = yes
[BOOK] #This is the name of the share it will show up as when you browse
comment = book drive
path = /mnt/usb/book
create mask = 0775
directory mask = 0775
read only = no
browseable = yes
public = yes
force user = pi
#force user = root
only guest = no
EOF

sudo smbpasswd -a pi
sudo service smbd restart
sudo service nmbd restart
echo "samba setup"

cd /home/pi/bookshelf/sysd/
sudo cp samba_mount.service /etc/systemd/system/
sudo cp samba_mount.sh /home/pi

cd /home/pi
sudo chmod 664 /home/pi/samba_mount.sh
sudo chmod 664 /etc/systemd/system/samba_mount.service

sudo systemctl daemon-reload
sudo systemctl enable samba_mount.service
sudo systemctl start samba_mount.service

