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


##Scanning

. /etc/openwrt_release

echo -e "${YELLOW} 
 _____ _____ _____ _____ _ _ _ _____ __    __    
|  _  |  _  |   __|   __| | | |  _  |  |  |  |   
|   __|     |__   |__   | | | |     |  |__|  |__ 
|__|  |__|__|_____|_____|_____|__|__|_____|_____|
                                                
${NC}"

echo "OPENWRT VERSION: $DISTRIB_RELEASE"

# RESULT=`echo "$DISTRIB_RELEASE" | grep -o 23 | sed -n '1p'`

# if [ "$RESULT" == "23" ]; then


echo " "
echo -e "${YELLOW} 1.${NC} ${CYAN} Passwall 1 ${NC}"
echo -e "${YELLOW} 2.${NC} ${CYAN} Passwall 2 ${NC}"
echo -e "${YELLOW} 4.${NC} ${RED} EXIT ${NC}"
echo ""


echo " "
 read -p " -Select Passwall Version : " choice

    case $choice in

1)

echo "Installing Passwall 1 ..."

sleep 2

rm -f passwall.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/Passwall/main/passwall.sh && chmod 777 passwall.sh && sh passwall.sh


;;

2)
        
echo "Installing Passwall 2 ..."

sleep 2

rm -f passwall2x.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/Passwall/main/passwall2x.sh && chmod 777 passwall2x.sh && sh passwall2x.sh

 
;;

4)
            echo ""
            echo -e "${GREEN}Exiting...${NC}"
            exit 0

           read -s -n 1
           ;;

 *)
           echo "  Invalid option Selected ! "
           echo " "
           echo -e "  Press ${RED}ENTER${NC} to continue"
           exit 0
           read -s -n 1
           ;;
      esac

