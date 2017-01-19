#!/bin/bash


sudo apt-get remove --purge hostapd -y
sudo apt-get remove --purge isc-dhcp-server -y

sudo apt-get install hostapd isc-dhcp-server -y
sudo apt-get install iptables-persistent -y

sudo hostnamectl set-hostname shelfa

cat > /etc/dhcp/dhcpd.conf<<EOF
authoritative
subnet 192.168.42.0 netmask 255.255.255.0 {
range 192.168.42.10 192.168.42.50;
option broadcast-address 192.168.42.255;
option routers 192.168.42.1;
default-lease-time 600;
max-lease-time 7200;
option domain-name "local";
option domain-name-servers 8.8.8.8, 8.8.4.4;
}
EOF

cat > /etc/hostapd/hostapd.conf<<EOF
interface=wlan0
ssid=Shelf_AP
country_code=US
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=MicroSan12d
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP 
rsn_pairwise=CCMP
wpa_group_rekey=86400
ieee80211n=1
wme_enabled=1
EOF

cat > /etc/default/hostapd<<EOF
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF

cat > /etc/dhcpcd.conf<<EOF
interface wlan0
static ip_address=192.168.42.50/24
static routers=192.168.42.1
static domain_name_servers=192.168.42.1
EOF

cat > /etc/default/isc-dhcp-server<<EOF
INTERFACES="wlan0"
EOF

sudo service hostapd start
sudo service isc-dhcp-server start

echo "sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf"



