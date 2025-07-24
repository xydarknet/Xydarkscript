#!/bin/bash
# Renew akun Trojan

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}Renew Akun Trojan${NC}"

read -rp "Masukkan username yang ingin diperpanjang: " user
if ! grep -qw "$user" /etc/xray/config.json; then
  echo -e "${RED}User tidak ditemukan!${NC}"
  exit 1
fi

read -rp "Berapa hari tambahan: " hari
if ! [[ "$hari" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}Input tidak valid!${NC}"
  exit 1
fi

newexp=$(date -d "+$hari days" +"%Y-%m-%d")

echo -e "${YELLOW}User $user diperpanjang sampai $newexp${NC}"

read -rp "Tekan Enter untuk kembali ke menu..."
bash /usr/bin/xray/menu-xray.sh
