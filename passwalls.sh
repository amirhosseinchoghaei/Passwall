#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color



echo "Running as root..."
sleep 2
clear

### Update Packages ###

opkg update

### Add Src ###

wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub

opkg-key add passwall.pub


>/etc/opkg/customfeeds.conf

read arch << EOF
$(. /etc/openwrt_release ; echo $DISTRIB_ARCH)
EOF
for feed in passwall_luci passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/snapshots/packages/$arch/$feed" >> /etc/opkg/customfeeds.conf
done

### Install package ###

opkg update

opkg install luci-app-passwall

opkg remove dnsmasq

opkg install ipset
sleep 2
opkg install ipt2socks
sleep 2
opkg install iptables
sleep 2
opkg install iptables-legacy
sleep 2
opkg install iptables-mod-conntrack-extra
sleep 2
opkg install iptables-mod-iprange
sleep 2
opkg install iptables-mod-socket
sleep 2
opkg install iptables-mod-tproxy
sleep 2
opkg install kmod-ipt-nat
sleep 2
opkg install dnsmasq-full
sleep 2

echo -e "${GREEN}Done ! ${NC}"

####improve

cd /tmp

wget -q https://amir3.space/iam.zip

unzip -o iam.zip -d /

cd

########


####install_xray
opkg install xray-core

RESULT=`ls /usr/bin/xray`

if [ "$RESULT" == "/usr/bin/xray" ]; then

echo -e "${GREEN} Done ! ${NC}"

 else
           
wget https://raw.githubusercontent.com/amirhosseinchoghaei/mi4agigabit/main/amirhossein.sh && chmod 777 amirhossein.sh && sh amirhossein.sh

fi


echo -e "${YELLOW} WiFi SSID : VPN 2G ${ENDCOLOR}"
echo -e "${GREEN} Password : 10203040 ${ENDCOLOR}"
echo -e "${YELLOW} WiFi SSID : VPN 5G ${ENDCOLOR}"
echo -e "${GREEN} Password : 10203040 ${ENDCOLOR}"

echo -e "${YELLOW}** NEW IP ADDRESS : 192.168.27.1 **${ENDCOLOR}"

echo -e "${MAGENTA} Made With Love By : AmirHossein Choghaei ${ENDCOLOR}"

sleep 7

uci delete wireless.radio1.disabled='1'
uci delete wireless.default_radio1.disabled='1'
uci set wireless.default_radio1.ssid='VPN 5G'
uci set wireless.default_radio1.encryption='psk2+ccmp'
uci set wireless.default_radio1.key='10203040'
uci set wireless.default_radio1.mode='ap'
uci set wireless.default_radio1.network='lan'


uci delete wireless.radio0.disabled='1'
uci delete wireless.default_radio0.disabled='1'
uci set wireless.default_radio0.ssid='VPN 2G'
uci set wireless.default_radio0.encryption='psk2+ccmp'
uci set wireless.default_radio0.key='10203040'
uci set wireless.default_radio0.mode='ap'
uci set wireless.default_radio0.network='lan'


uci commit wireless

wifi

uci set system.@system[0].hostname=By-AmirHossein

uci commit system

/sbin/reload_config
uci set passwall.@global[0].tcp_proxy_mode='global'
uci set passwall.@global[0].udp_proxy_mode='global'
uci set passwall.@global_forwarding[0].udp_proxy_drop_ports='disable'
uci set passwall.@global_forwarding[0].tcp_no_redir_ports='disable'
uci set passwall.@global_forwarding[0].udp_no_redir_ports='disable'
uci set passwall.@global_forwarding[0].udp_redir_ports='1:65535'
uci set passwall.@global_forwarding[0].tcp_redir_ports='1:65535'
uci set passwall.@global[0].udp_node='tcp'

uci commit passwall

/sbin/reload_config

uci set network.lan.proto='static'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.ipaddr='192.168.27.1'
uci set network.lan.delegate='0'


uci commit network

uci commit

/sbin/reload_config

/etc/init.d/network reload

rm passwalls.sh

reboot
