# openwrt
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
