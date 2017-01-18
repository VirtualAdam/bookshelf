
fo = open("/etc/wpa_supplicant/wpa_supplicant.conf", "w")
ssid1 = raw_input("SSID ")
password1 = raw_input("network password ")

fo.write( 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n'
          'update_config=1\ncountry=US\n\nnetwork={\nssid="'+ssid1+'"\nscan_ssid=1\npsk="'+password1+'"\nproto=RSN\n'
          'key_mgmt=WPA-PSK\npairwise=CCMP\nauth_alg=OPEN\npriority=5\n}\n')
fo.close()

fo1 = open("/etc/network/interfaces", "w")
fo1.write("source-directory /etc/network/interfaces.d\n\nauto wlan0\nauto lo\n"
          "iface lo inet loopback\n\niface eth0 inet manual\n\nallow-hotplug wlan0\n" \
          "iface wlan0 inet dhcp\nwpa-conf /etc/wpa_supplicant/wpa_supplicant.conf\n" \
          "\nallow-hotplug wlan1\niface wlan1 inet dhcp\n" \
          "wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf\n")
fo1.close()