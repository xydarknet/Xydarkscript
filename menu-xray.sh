#!/bin/bash

# Warna
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}───────────────────────────────${NC}"
echo -e "${CYAN}         Xray Tunnel Menu       ${NC}"
echo -e "${GREEN}───────────────────────────────${NC}"

echo -e "${YELLOW} 1)${NC} Add VLESS WS & gRPC"
echo -e "${YELLOW} 2)${NC} Add Trojan WS & gRPC"
echo -e "${YELLOW} 3)${NC} Renew Akun VLESS/Trojan"
echo -e "${YELLOW} 4)${NC} Change UUID Akun"
echo -e "${YELLOW} 5)${NC} Cek Login Aktif"
echo -e "${YELLOW} 6)${NC} Update Script"
echo -e "${RED} 0)${NC} Keluar"

echo -ne "\n${CYAN}Pilih opsi: ${NC}"
read -r pilihan

case $pilihan in
  1) /usr/bin/xray/addvless.sh ;;
  2) /usr/bin/xray/addtrojan.sh ;;
  3) /usr/bin/xray/renewvless.sh ;;
  4) /usr/bin/xray/uuidvless.sh ;;
  5) /usr/bin/xray/ceklog.sh ;;
  6) update ;;
  0) echo -e "${RED}Keluar...${NC}"; exit 0 ;;
  *) echo -e "${RED}Opsi tidak valid!${NC}"; sleep 1; /usr/bin/xray/menu-xray.sh ;;
esac
