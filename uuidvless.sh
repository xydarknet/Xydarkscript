#!/bin/bash
# Ganti UUID akun VLESS

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}Ganti UUID Akun VLESS${NC}"

read -rp "Masukkan username: " user
if ! grep -qw "$user" /etc/xray/config.json; then
  echo -e "${RED}User tidak ditemukan!${NC}"
  exit 1
fi

newuuid=$(cat /proc/sys/kernel/random/uuid)

jq --arg user "$user" --arg newuuid "$newuuid" \
  '(.inbounds[0].settings.clients[] | select(.email == $user)).id = $newuuid' \
  /etc/xray/config.json > /etc/xray/config.tmp && mv /etc/xray/config.tmp /etc/xray/config.json

systemctl restart xray

echo -e "${YELLOW}UUID untuk user $user berhasil diubah ke $newuuid${NC}"

read -rp "Tekan Enter untuk kembali ke menu..."
bash /usr/bin/xray/menu-xray.sh
