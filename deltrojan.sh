#!/bin/bash
# Hapus akun Trojan

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}Hapus Akun Trojan${NC}"

read -rp "Masukkan username yang ingin dihapus: " user
if ! grep -qw "$user" /etc/xray/config.json; then
  echo -e "${RED}User tidak ditemukan!${NC}"
  exit 1
fi

jq --arg user "$user" \
  '(.inbounds[1].settings.clients) |= map(select(.email != $user))' \
  /etc/xray/config.json > /etc/xray/config.tmp && mv /etc/xray/config.tmp /etc/xray/config.json

systemctl restart xray

echo -e "${YELLOW}User $user berhasil dihapus.${NC}"

read -rp "Tekan Enter untuk kembali ke menu..."
bash /usr/bin/xray/menu-xray.sh
