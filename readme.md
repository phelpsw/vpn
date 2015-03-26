
## Setup
```
sudo apt-get install iptables unzip openvpn
mkdir vpn
rm vpn/on
rm -Rf /tmp/pia
bash pia_setup.sh

wget --directory-prefix=/home/$USER/vpn/ https://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip ~/vpn/openvpn.zip -d /home/$USER/vpn/

cd /home/$USER/vpn/
sudo openvpn US\ California.ovpn

```

## Disabling
```
sudo iptables -F
```

## Enabling rules breaks routes for some reason:
```
sudo ./on
```
