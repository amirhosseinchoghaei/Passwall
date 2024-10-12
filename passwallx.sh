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

uci set system.@system[0].timezone='<+0330>-3:30'

uci commit

/sbin/reload_config

cp passwallx.sh /sbin/passwall

##Scanning

. /etc/openwrt_release

echo -e "${YELLOW} 
 _____ _____ _____ _____ _ _ _ _____ __    __    
|  _  |  _  |   __|   __| | | |  _  |  |  |  |   
|   __|     |__   |__   | | | |     |  |__|  |__ 
|__|  |__|__|_____|_____|_____|__|__|_____|_____|
                                                
${NC}"
EPOL=`cat /tmp/sysinfo/model`
echo " - Model : $EPOL"
echo " - System Ver : $DISTRIB_RELEASE"
echo " - System Arch : $DISTRIB_ARCH"

# RESULT=`echo "$DISTRIB_RELEASE" | grep -o 23 | sed -n '1p'`

# if [ "$RESULT" == "23" ]; then


echo " "
RESULTT=`ls /etc/init.d/passwall 2>/dev/null`
if [ "$RESULTT" == "/etc/init.d/passwall" ]; then

echo -e "${YELLOW} > 4.${NC} ${GREEN} Update Your Passwall ${NC}"

 else
           
sleep 1

fi

RESULTTT=`ls /etc/init.d/passwall2 2>/dev/null`
if [ "$RESULTTT" == "/etc/init.d/passwall2" ]; then

echo -e "${YELLOW} > 5.${NC} ${GREEN} Update Your Passwall2 ${NC}"

 else
           
sleep 1

fi

echo -e "${YELLOW} 1.${NC} ${CYAN} Install Passwall 1 ${NC}"
echo -e "${YELLOW} 2.${NC} ${CYAN} Install Passwall 2 ( Requires a +256 MB RAM )${NC}"
echo -e "${YELLOW} 3.${NC} ${CYAN} Install Passwall 2 + Mahsa Core${NC}"
echo -e "${YELLOW} 9.${NC} ${YELLOW} CloudFlare IP Scanner ${NC}"
echo -e "${YELLOW} 6.${NC} ${RED} EXIT ${NC}"
echo ""


echo " "
 read -p " -Select Passwall Option : " choice

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

9)
        
echo "Installing CloudFlare IP SCAN ..."

opkg update

opkg install bash

opkg install curl

curl -ksSL https://gitlab.com/rwkgyg/cdnopw/raw/main/cdnopw.sh -o cdnopw.sh && bash cdnopw.sh
 
;;


4)
        
echo "Updating Passwall v1"

opkg update

opkg install luci-app-passwall
 
;;


5)
        
echo "Updating Passwall v2"

opkg update

opkg install luci-app-passwall2
 
;;


6)
            echo ""
            echo -e "${GREEN}Exiting...${NC}"
            exit 0

           read -s -n 1
           ;;

 3)

echo "Installing Passwall 2 With Mahsa Core ..."

sleep 2

rm -f mahsa.sh && wget https://raw.githubusercontent.com/amirhosseinchoghaei/Passwall/refs/heads/main/mahsa.sh && chmod 777 mahsa.sh && sh mahsa.sh


;;


 *)
           echo "  Invalid option Selected ! "
           echo " "
           echo -e "  Press ${RED}ENTER${NC} to continue"
           exit 0
           read -s -n 1
           ;;
      esac

