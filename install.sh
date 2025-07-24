#!/bin/bash
# ===================================================
# Xydarkscript Installer - Xray WS + gRPC (VLESS & Trojan)
# Author: xydarknet
# ===================================================

# Warna
GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}=== Mulai instalasi Xray WS + gRPC VLESS & Trojan ===${NC}"

# Validasi IP
MYIP=$(curl -s ipv4.icanhazip.com)
ALLOWED_IPS_URL="https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/allow"
if ! curl -s "$ALLOWED_IPS_URL" | grep -qw "$MYIP"; then
  echo -e "${RED}IP $MYIP tidak terdaftar di daftar izin.${NC}"
  exit 1
fi

# Input domain
read -rp "Masukkan domain Anda: " DOMAIN
if [[ -z "$DOMAIN" ]]; then
  echo -e "${RED}Domain wajib diisi!${NC}"
  exit 1
fi
echo "$DOMAIN" > /etc/xray/domain

# Update sistem & install dependensi
echo -e "${YELLOW}Mengupdate sistem dan install dependensi...${NC}"
apt update -y && apt upgrade -y
apt install -y curl socat cron wget unzip bash-completion jq qrencode

# Pasang acme.sh
echo -e "${YELLOW}Install acme.sh dan generate sertifikat SSL...${NC}"
curl https://get.acme.sh | sh
export PATH=~/.acme.sh:$PATH

~/.acme.sh/acme.sh --register-account -m admin@$DOMAIN --force
~/.acme.sh/acme.sh --issue -d $DOMAIN --standalone -k ec-256 --force
~/.acme.sh/acme.sh --install-cert -d $DOMAIN \
  --fullchainpath /etc/xray/xray.crt \
  --keypath /etc/xray/xray.key \
  --ecc --force

# Download xray-core terbaru
echo -e "${YELLOW}Download dan pasang Xray-core terbaru...${NC}"
curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip
unzip -o /tmp/xray.zip -d /usr/local/bin/
chmod +x /usr/local/bin/xray
rm /tmp/xray.zip

# Setup folder dan file config
mkdir -p /etc/xray /etc/xray/qr /etc/xray/uuid /etc/xray/log
echo "$DOMAIN" > /etc/xray/domain

# Buat config.json multi inbound (WS & gRPC VLESS + Trojan)
curl -s https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/config/xray-config.json -o /etc/xray/config.json

# Setup systemd service
cat <<EOF >/etc/systemd/system/xray.service
[Unit]
Description=Xray Service
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray -config /etc/xray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable xray
systemctl restart xray

# Download dan set permission script modular (menu & fungsi)
mkdir -p /usr/bin/xray
cd /usr/bin/xray

# Contoh download modul (saya buatkan nanti file modular terpisah)
# wget -q https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/menu-xray.sh
# chmod +x menu-xray.sh

# Alias update-script
echo "alias update='bash <(curl -s https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/update.sh)'" >> ~/.bashrc

echo -e "${GREEN}Instalasi selesai! Jalankan perintah 'menu' untuk membuka menu utama.${NC}"
