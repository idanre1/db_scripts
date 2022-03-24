# openwrt installation
https://openwrt.org/docs/guide-user/network/wifi/dumbap  
https://openwrt.org/docs/guide-user/firewall/fw3_configurations/bridge  
https://openwrt.org/docs/guide-user/firewall/fw3_configurations/dns_ipset  
## Interfaces
Only 1: lan (bridge eth.0 and wlan0)  
Basicaly assign static IP to AP out of master router DHCP range  
Assign default gateway to master router 
Assign DNS server as master router
Disable dnsmasq and odhcpd from startup
## Installations
1. bridge filter
```sh
# Install packages
opkg update
opkg install kmod-br-netfilter
 
# Configure kernel parameters
cat << EOF >> /etc/sysctl.conf
net.bridge.bridge-nf-call-arptables=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF
/etc/init.d/sysctl restart
```
2.Selective forwarding (e.g. DNS from wlan to lan)
```sh
# Install packages
opkg update
opkg install iptables-mod-physdev
 
# Deny LAN1 to LAN2 forwarding
uci -q delete firewall.lan_wlan0_dns_block
uci set firewall.lan_wlan0_dns_block="rule"
uci set firewall.lan_wlan0_dns_block.name="Deny-LAN-WLAN-DNS"
uci set firewall.lan_wlan0_dns_block.src="lan"
uci set firewall.lan_wlan0_dns_block.dest="lan"
uci set firewall.lan_wlan0_dns_block.dest_port="53"
uci set firewall.lan_wlan0_dns_block.extra="-m physdev --physdev-in wlan0 --physdev-out eth0.1"
uci set firewall.lan_wlan0_dns_block.proto="tcp udp"
uci set firewall.lan_wlan0_dns_block.target="REJECT"
uci commit firewall
/etc/init.d/firewall restart
```
3. verify
`cat /etc/config/firewall`

---

# openwrt archive
## dnsmasq
https://github.com/imp/dnsmasq/blob/master/dnsmasq.conf.example  
Inside `/etc/dnsmasq.conf`
```
# tuya to NXDOMAIN
# https://alblue.bandlem.com/2020/05/using-dnsmasq.html
address=/tuya.com/
```
## firewall
https://forum.openwrt.org/t/how-to-block-outgoing-access-to-single-fixed-ip/40269  
Using Luci
1.    select Network->Firewall
2.    select Traffic Rules
3.    scroll down to New Forward Rule
4.    select Add and edit
5.    change source zone to LAN , destination zone to WAN and set the destination address to "AAA.BBB. CCC. DDD" and action to reject.
6.    save and apply the changes
