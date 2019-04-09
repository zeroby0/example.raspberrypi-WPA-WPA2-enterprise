# Connect Raspberrypi to WPA/WPA2-Enterprise

- Tested on IIITB-Milan
- Add these lines to your `/etc/wpa_supplicant/wpa_supplicant.conf`
```
network={
        ssid="IIITB-Milan"
        proto=RSN
        key_mgmt=WPA-EAP
        pairwise=CCMP TKIP
        group=CCMP TKIP
        identity="iiitb\user.name"
        password="Your password"
        phase1="peaplabel=0"
        phase2="auth=MSCHAPV2"
}
```

- Add these to your `/etc/network/interface`
```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
    pre-up wpa_supplicant -B -Dwext -i wlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
    post-down killall -q wpa_supplicant
```
- Restart you pi

----

- Edit files as root with sudo. `ctrl-shift-v` to paste to terminal.
- I found ethernet to be orders of magnitude faster with 3B. Use ethernet for large downloads.
