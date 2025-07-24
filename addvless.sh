#!/bin/bash
# Tambah akun VLESS WS + gRPC

GREEN='\e[32m'
YELLOW='\e[33m'
NC='\e[0m'

clear
echo -e "${GREEN}Tambah Akun VLESS WS + gRPC${NC}"

read -rp "Username (alphanumeric): " user
if [[ ! $user =~ ^[a-zA-Z0-9_]+$ ]]; then
  echo -e "${YELLOW}Username tidak valid! Gunakan huruf/angka/underscore saja.${NC}"
  exit 1
fi

# Cek user sudah ada?
if grep -qw "$user" /etc/xray/config.json; then
  echo -e "${YELLOW}User sudah ada, gunakan username lain.${NC}"
  exit 1
fi

# Generate UUID
uuid=$(cat /proc/sys/kernel/random/uuid)

# Set masa aktif
read -rp "Berapa hari aktif: " aktif
if ! [[ "$aktif" =~ ^[0-9]+$ ]]; then
  echo -e "${YELLOW}Input tidak valid.${NC}"
  exit 1
fi
exp=$(date -d "+$aktif days" +"%Y-%m-%d")

# Tambahkan user ke config.json
jq --arg user "$user" --arg uuid "$uuid" --arg exp "$exp" \
   '.inbounds[0].settings.clients += [{"id":$uuid,"email":$user}] | .inbounds[1].settings.clients += [{"password":$uuid,"email":$user}]' \
   /etc/xray/config.json > /etc/xray/config.tmp && mv /etc/xray/config.tmp /etc/xray/config.json

# Restart Xray
systemctl restart xray

# Buat link VLESS WS dan gRPC
domain=$(cat /etc/xray/domain)
vless_ws="vless://${uuid}@${domain}:443?type=ws&security=tls&path=/vless#${user}_ws"
vless_grpc="vless://${uuid}@${domain}:443?mode=gun&security=tls&serviceName=vless-grpc#${user}_grpc"

echo -e "${GREEN}Akun berhasil dibuat:${NC}"
echo "Username: $user"
echo "UUID: $uuid"
echo "Expired: $exp"
echo "Link WS: $vless_ws"
echo "Link gRPC: $vless_grpc"

read -rp "Tekan Enter untuk kembali ke menu..."
bash /usr/bin/xray/menu-xray.sh
