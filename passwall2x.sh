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

. /etc/openwrt_release
OPENWRT_MAJOR="${DISTRIB_RELEASE%%.*}"
release="${DISTRIB_RELEASE%.*}"
arch="$DISTRIB_ARCH"

SNNAP=$(grep -o SNAPSHOT /etc/openwrt_release | sed -n '1p')

if [ "$SNNAP" == "SNAPSHOT" ]; then
    echo -e "${YELLOW} SNAPSHOT Version Detected ! ${NC}"
    rm -f passwalls.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/Passwall/main/passwalls.sh && chmod 777 passwalls.sh && sh passwalls.sh
    exit 1
fi

### Check Version & Install Packages ###

if [ "$OPENWRT_MAJOR" -ge 25 ]; then
    echo -e "${GREEN} OpenWrt 25+ Detected (Using APK) ... ${NC}"

    mkdir -p /etc/apk/keys /etc/apk/repositories.d
    wget -O /etc/apk/keys/passwall.pub https://sourceforge.net/projects/openwrt-passwall-build/files/apk.pub

    cat > /etc/apk/repositories.d/customfeeds.list <<EOF
https://sourceforge.net/projects/openwrt-passwall-build/files/releases/packages-${release}/${arch}/passwall_packages/packages.adb
https://sourceforge.net/projects/openwrt-passwall-build/files/releases/packages-${release}/${arch}/passwall_luci/packages.adb
https://sourceforge.net/projects/openwrt-passwall-build/files/releases/packages-${release}/${arch}/passwall2/packages.adb
EOF

    apk update
    apk add tcping geoview
    apk add luci-app-passwall2 xray-core ca-bundle ipset kmod-tun

else
    echo -e "${GREEN} OpenWrt < 25 Detected (Using OPKG) ... ${NC}"

    opkg update
    wget -O passwall.pub https://master.dl.sourceforge.net/project/openwrt-passwall-build/ipk.pub
    opkg-key add passwall.pub
    
> /etc/opkg/customfeeds.conf
    
read release arch << EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} $DISTRIB_ARCH)
EOF
for feed in passwall_packages passwall2; do
  echo "src/gz $feed https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed" >> /etc/opkg/customfeeds.conf
done

    opkg update
    sleep 3
    opkg remove dnsmasq
    sleep 3
    opkg install dnsmasq-full
    sleep 2
    opkg install wget-ssl unzip luci-app-passwall2
    sleep 2
    opkg install kmod-nft-socket kmod-nft-tproxy ca-bundle kmod-inet-diag kernel kmod-netlink-diag kmod-tun ipset
    sleep 2
    opkg install xray-core
fi

> /etc/banner

echo "    ___    __  ___________  __  ______  __________ ___________   __
   /   |  /  |/  /  _/ __ \/ / / / __ \/ ___/ ___// ____/  _/ | / /
  / /| | / /|_/ // // /_/ / /_/ / / / /\__ \\__ \ / __/  / //  |/ /
 / ___ |/ /  / // // _  _/ __  / /_/ /___/ /__/ / /____/ // /|  /
/_/  |_/_/  /_/___/_/ |_/_/ /_/\____//____/____/_____/___/_/ |_/                                                                                                                                           
telegram : @AmirHosseinTSL" >> /etc/banner

sleep 1

RESULT5=$(ls /etc/init.d/passwall2 2>/dev/null)

if [ "$RESULT5" == "/etc/init.d/passwall2" ]; then
    echo -e "${GREEN} Passwall.2 Installed Successfully ! ${NC}"
else
    echo -e "${RED} Can not Download Packages ... Check your internet Connection . ${NC}"
    exit 1
fi

if [ "$OPENWRT_MAJOR" -lt 25 ]; then
    DNS=$(ls /usr/lib/opkg/info/dnsmasq-full.control 2>/dev/null)
    if [ "$DNS" == "/usr/lib/opkg/info/dnsmasq-full.control" ]; then
        echo -e "${GREEN} dnsmasq-full Installed successfully ! ${NC}"
    else
        echo -e "${RED} Package : dnsmasq-full not installed ! (Bad internet connection .) ${NC}"
        exit 1
    fi
fi

#### Check Xray ####
RESULT=$(ls /usr/bin/xray 2>/dev/null)

if [ "$RESULT" == "/usr/bin/xray" ]; then
    echo -e "${GREEN} XRAY : OK ! ${NC}"
else
    echo -e "${YELLOW} XRAY : NOT INSTALLED X ${NC}"
    sleep 2
    echo -e "${YELLOW} Trying to install Xray on temp Space ... ${NC}"
    sleep 2
    rm -f amirhossein.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/mi4agigabit/main/amirhossein.sh && chmod 777 amirhossein.sh && sh amirhossein.sh
fi

#### PassWall 2 Configs ####
uci set system.@system[0].zonename='Asia/Tehran'
uci set system.@system[0].timezone='<+0330>-3:30'

uci set passwall2.@global_forwarding[0]=global_forwarding
uci set passwall2.@global_forwarding[0].tcp_no_redir_ports='disable'
uci set passwall2.@global_forwarding[0].udp_no_redir_ports='disable'
uci set passwall2.@global_forwarding[0].tcp_redir_ports='1:65535'
uci set passwall2.@global_forwarding[0].udp_redir_ports='1:65535'
uci set passwall2.@global[0].remote_dns='8.8.4.4'

uci set passwall2.Direct=shunt_rules
uci set passwall2.Direct.network='tcp,udp'
uci set passwall2.Direct.remarks='IRAN'
uci set passwall2.Direct.ip_list='0.0.0.0/8
10.0.0.0/8
100.64.0.0/10
127.0.0.0/8
169.254.0.0/16
172.16.0.0/12
192.0.0.0/24
192.0.2.0/24
192.88.99.0/24
192.168.0.0/16
198.19.0.0/16
198.51.100.0/24
203.0.113.0/24
224.0.0.0/4
240.0.0.0/4
255.255.255.255/32
::/128
::1/128
::ffff:0:0:0/96
64:ff9b::/96
100::/64
2001::/32
2001:20::/28
2001:db8::/32
2002::/16
fc00::/7
fe80::/10
ff00::/8
geoip:ir'
uci set passwall2.Direct.domain_list='regexp:^.+\.ir$
geosite:category-ir'

uci set passwall2.myshunt.Direct='_direct'

uci commit passwall2
uci commit system

uci set system.@system[0].hostname=By-AmirHossein
uci commit system

uci set dhcp.@dnsmasq[0].rebind_domain='www.ebanksepah.ir 
my.irancell.ir'
uci commit

echo -e "${YELLOW}** Installation Completed ** ${NC}"
echo -e "${MAGENTA} Made With Love By : AmirHossein ${NC}"

rm -f passwall2x.sh passwallx.sh

/sbin/reload_config
