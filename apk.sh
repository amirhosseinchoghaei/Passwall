#!/bin/sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing Passwall2 for OpenWrt APK...${NC}"
sleep 1

########################################
# Update APK
########################################

apk update || exit 1

########################################
# Install Required Packages
########################################

echo -e "${YELLOW}Installing required packages...${NC}"

apk del dnsmasq 2>/dev/null

apk add dnsmasq-full
apk add kmod-nft-tproxy
apk add kmod-nft-socket

########################################
# Install Passwall Repository Key
########################################

mkdir -p /etc/apk/keys

wget -q -O /etc/apk/keys/passwall.pem \
https://master.dl.sourceforge.net/project/openwrt-passwall-build/apk.pub

########################################
# Detect Release & Architecture
########################################

read release arch <<EOF
$(. /etc/openwrt_release ; echo ${DISTRIB_RELEASE%.*} ${DISTRIB_ARCH})
EOF

echo "OpenWrt Version : $release"
echo "Architecture    : $arch"

########################################
# Add Repository
########################################

mkdir -p /etc/apk/repositories.d

CUSTOM_FEED="/etc/apk/repositories.d/customfeeds.list"

touch "$CUSTOM_FEED"

for feed in passwall_packages passwall2
do

URL="https://master.dl.sourceforge.net/project/openwrt-passwall-build/releases/packages-$release/$arch/$feed/packages.adb"

grep -qxF "$URL" "$CUSTOM_FEED" || echo "$URL" >> "$CUSTOM_FEED"

done

########################################
# Update Repository
########################################

apk update

########################################
# Install Passwall2
########################################

echo -e "${GREEN}Installing Passwall2...${NC}"

apk add luci-app-passwall2
apk add xray-core

########################################
# Remove Old Shunt Rules
########################################

for s in $(uci show passwall2 | sed -n 's/^passwall2\.\([^=]*\)=shunt_rules$/\1/p')
do
    uci delete passwall2.$s
done

uci commit passwall2

########################################
# Create Iran Rule
########################################

uci -q delete passwall2.Iran

uci set passwall2.Iran='shunt_rules'
uci set passwall2.Iran.remarks='Iran'
uci set passwall2.Iran.network='tcp,udp'
uci set passwall2.Iran.domain_list='geosite:category-ir'
uci set passwall2.Iran.ip_list='geoip:ir'

uci commit passwall2

########################################
# DNS Rebind
########################################

for domain in \
banksepah.ir \
ebanksepah.ir \
gov.ir \
medu.ir \
qmb.ir \
tamin.ir
do

uci add_list dhcp.@dnsmasq[0].rebind_domain="$domain"

done

uci commit dhcp

/etc/init.d/dnsmasq restart

########################################
# Restart Passwall2
########################################

if [ -f /etc/init.d/passwall2 ]; then
    /etc/init.d/passwall2 restart
fi

echo
echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN} Passwall2 Installed Successfully! ${NC}"
echo -e "${GREEN}====================================${NC}"
