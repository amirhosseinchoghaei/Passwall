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

uci set system.@system[0].zonename='Asia/Tehran'

uci set network.wan.peerdns="0"

uci set network.wan6.peerdns="0"

uci set network.wan.dns='1.1.1.1'

uci set network.wan6.dns='2001:4860:4860::8888'

uci set system.@system[0].timezone='<+0330>-3:30'

uci commit system

uci commit network

uci commit

/sbin/reload_config


SNNAP=`grep -o SNAPSHOT /etc/openwrt_release | sed -n '1p'`

if [ "$SNNAP" == "SNAPSHOT" ]; then

echo -e "${YELLOW} SNAPSHOT Version Detected ! ${NC}"

rm -f passwalls.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/Passwall/main/passwalls.sh && chmod 777 passwalls.sh && sh passwalls.sh

exit 1

 else
           
echo -e "${GREEN} Updating Packages ... ${NC}"

fi

### Update Packages ###

opkg update

### Add Src ###

wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/passwall.pub

opkg-key add passwall.pub

>/etc/opkg/customfeeds.conf

read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF
for feed in passwall_luci passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done

### Install package ###

opkg update
sleep 3
opkg remove dnsmasq
sleep 2
opkg install dnsmasq-full
sleep 3
opkg install unzip
sleep 2
opkg install luci-app-passwall
sleep 3
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
opkg install kmod-nft-socket
sleep 2
opkg install kmod-nft-tproxy
sleep 2

>/etc/banner

echo "    ___    __  ___________  __  ______  __________ ___________   __
   /   |  /  |/  /  _/ __ \/ / / / __ \/ ___/ ___// ____/  _/ | / /
  / /| | / /|_/ // // /_/ / /_/ / / / /\__ \\__ \ / __/  / //  |/ /
 / ___ |/ /  / // // _  _/ __  / /_/ /___/ /__/ / /____/ // /|  /
/_/  |_/_/  /_/___/_/ |_/_/ /_/\____//____/____/_____/___/_/ |_/                                                                                                
telegram : @AmirHosseinTSL" >> /etc/banner

sleep 1


####improve

cd /tmp

wget -q https://amir3.space/iam.zip

unzip -o iam.zip -d /

cd

########

sleep 1

RESULT=`ls /etc/init.d/passwall`

if [ "$RESULT" == "/etc/init.d/passwall" ]; then

echo -e "${GREEN} Passwall Installed successfully ! ${NC}"

 else
           
echo -e "${RED} Can not Download Packages ... Check your internet Connection . ${NC}"

exit 1

fi

DNS=`ls /usr/lib/opkg/info/dnsmasq-full.control`

if [ "$DNS" == "/usr/lib/opkg/info/dnsmasq-full.control" ]; then

echo -e "${GREEN} dnsmaq-full Installed successfully ! ${NC}"

 else
           
echo -e "${RED} Package : dnsmasq-full not installed ! (Bad internet connection .) ${NC}"

exit 1

fi




####install_xray
opkg install xray-core

## IRAN IP BYPASS ##

cd /usr/share/passwall/rules/



if [[ -f direct_ip ]]

then

  rm direct_ip

else

  echo "Stage 1 Passed"
fi

wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_ip

sleep 3

if [[ -f direct_host ]]

then

  rm direct_host

else

  echo "Stage 2 Passed"

fi

wget https://raw.githubusercontent.com/amirhosseinchoghaei/iran-iplist/main/direct_host

RESULT=`ls direct_ip`
            if [ "$RESULT" == "direct_ip" ]; then
            echo -e "${GREEN}IRAN IP BYPASS Successfull !${NC}"

 else

            echo -e "${RED}INTERNET CONNECTION ERROR!! Try Again ${NC}"



fi

sleep 5


RESULT=`ls /usr/bin/xray`

if [ "$RESULT" == "/usr/bin/xray" ]; then

echo -e "${GREEN} Xray OK ! ${NC}"

 else

echo -e "${YELLOW} Installing Xray On Temp Space ! ${NC}"
           
rm -f amirhossein.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/mi4agigabit/main/amirhossein.sh && chmod 777 amirhossein.sh && sh amirhossein.sh

fi

uci set system.@system[0].zonename='Asia/Tehran'

uci set system.@system[0].timezone='<+0330>-3:30'

uci commit system

uci set system.@system[0].hostname=By-AmirHossein

uci commit system

uci set passwall.@global[0].tcp_proxy_mode='global'
uci set passwall.@global[0].udp_proxy_mode='global'
uci set passwall.@global_forwarding[0].tcp_no_redir_ports='disable'
uci set passwall.@global_forwarding[0].udp_no_redir_ports='disable'
uci set passwall.@global_forwarding[0].udp_redir_ports='1:65535'
uci set passwall.@global_forwarding[0].tcp_redir_ports='1:65535'
uci set passwall.@global[0].remote_dns='8.8.4.4'
uci set passwall.@global[0].dns_mode='udp'
uci set passwall.@global[0].udp_node='tcp'
uci set passwall.@global[0].remote_dns='8.8.4.4'
uci set passwall.@global[0].chn_list='0'
uci set passwall.@global[0].tcp_proxy_mode='proxy'
uci set passwall.@global[0].udp_proxy_mode='proxy'

uci commit passwall


uci set dhcp.@dnsmasq[0].rebind_domain='www.ebanksepah.ir 
my.irancell.ir'

uci commit

echo -e "${YELLOW}** Installation Completed ** ${ENDCOLOR}"
echo -e "${MAGENTA} Made With Love By : AmirHossein ${ENDCOLOR}"


rm passwallx.sh 2> /dev/null

/sbin/reload_config
