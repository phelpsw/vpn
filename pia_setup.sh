#!/bin/bash

mkdir /tmp/pia/
wget -q --directory-prefix=/tmp/pia/ https://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip -q /tmp/pia/openvpn.zip -d /tmp/pia/
grep -h "remote " /tmp/pia/*ovpn | cut -d ' ' -f 2 | sort -u > /tmp/piaservers
dig -f /tmp/piaservers A +short | sort > /tmp/piaserverips

# Start building iptables script - starts by overwriting old file
echo "#!/bin/bash" > /home/$USER/vpn/on
echo "iptables -F" > /home/$USER/vpn/on
echo "iptables -A INPUT -i tun+ -j ACCEPT" >> /home/$USER/vpn/on
echo "iptables -A OUTPUT -o tun+ -j ACCEPT" >> /home/$USER/vpn/on
echo "iptables -A INPUT -s 127.0.0.1 -j ACCEPT" >> /home/$USER/vpn/on
echo "iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT" >> /home/$USER/vpn/on

# Add PIA server IPs to script
IP_LIST=$(tr '\n' ' ' < /tmp/piaserverips)
for IP in $IP_LIST; do
    echo "iptables -A INPUT -s" $IP "-j ACCEPT" >> /home/$USER/vpn/on
    echo "iptables -A OUTPUT -d" $IP "-j ACCEPT" >> /home/$USER/vpn/on
done

# Next two lines give me access to/from my internal servers
echo "iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT" >> /home/$USER/vpn/on
echo "iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT" >> /home/$USER/vpn/on
# Stop anything not from PIA or internal or localhost
echo "iptables -A INPUT -j DROP" >> /home/$USER/vpn/on
echo "iptables -A OUTPUT -j DROP" >> /home/$USER/vpn/on

chmod 744 /home/$USER/vpn/on
rm -r /tmp/piaservers /tmp/piaserverips /tmp/pia

