#!/bin/bash

# ◦•●◉✿ 01. FINAL INSTALL SCRIPT by xydark ✿◉●•◦
# Telegram: t.me/xydark
# Info: Auto setup tunneling server + Xray WS + gRPC + SSH + Telegram Notify

# ============================
# 02. Warna
# ============================
GREEN="\e[92m" YELLOW="\e[93m" RED="\e[91m" NC="\e[0m"

# ============================
# 03. Banner permanen SSH login (/etc/issue.net)
# ============================
echo -e "${GREEN}Setup Banner SSH...${NC}"
echo -e "\n  ░█▀▄░█▀█░█▀█░█▀▀░█▀▄░  by xydark" > /etc/issue.net
echo -e "  ░█░█░█▀█░█░█░█▀▀░█▀▄░  t.me/xydark" >> /etc/issue.net
echo -e "  ░▀▀░░▀░▀░▀░▀░▀▀▀░▀░▀░  SSH Access" >> /etc/issue.net
sed -i 's|#Banner none|Banner /etc/issue.net|' /etc/ssh/sshd_config
systemctl restart sshd

# === ✅ ATUR IPTABLES LEGACY (FIX DEBIAN 12) ===
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# =============== DISABLE IPV6 ===============
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p > /dev/null

# ============================
# 04. Fail2Ban + Firewall
# ============================
echo -e "${GREEN}Installing Fail2Ban & UFW...${NC}"
apt install fail2ban -y >/dev/null 2>&1
systemctl enable fail2ban
systemctl start fail2ban

ufw allow OpenSSH >/dev/null 2>&1
ufw allow 443
ufw allow 80
ufw allow 22
ufw allow 10000:60000/tcp
ufw allow 10000:60000/udp
ufw --force enable

# ============================
# 05. Struktur Folder Modular
# ============================
echo -e "${GREEN}Setup Struktur Folder...${NC}"
mkdir -p /etc/xray /etc/xray/config /etc/xray/log /etc/xray/limit /etc/xray/uuid
mkdir -p /etc/ssh /etc/ssh/config /etc/ssh/limit
mkdir -p /etc/telegram

# ============================
# 06. Install Dependency
# ============================
echo -e "${GREEN}Install Package Wajib...${NC}"
apt update -y && apt upgrade -y
apt install curl socat cron bash-completion wget unzip jq net-tools iptables-persistent -y

# ============================
# 07. Install Xray-Core
# ============================
echo -e "${GREEN}Installing Xray-Core...${NC}"
mkdir -p /usr/local/bin/xray
curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip
unzip xray.zip -d /usr/local/bin/xray
chmod +x /usr/local/bin/xray/xray

# ============================
# 08. Setup Telegram BOT Token & Chat ID
# ============================
echo -e "${GREEN}Setup Telegram Notifikasi...${NC}"
BOT_TOKEN="7986904946:AAGdeQpLTROH0vrjDR2gj3HGlmc2fb5ijkw"
CHAT_ID="-4939887004"
echo "$BOT_TOKEN" > /etc/telegram/bot_token
echo "$CHAT_ID" > /etc/telegram/chat_id

# ============================
# 09. Download & Jalankan Modular Script
# ============================
echo -e "${GREEN}Download Modular Script...${NC}"
cd /usr/bin
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-xray.sh -O module-xray.sh
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-ssh.sh -O module-ssh.sh
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-telegram.sh -O module-telegram.sh
chmod +x module-*.sh

# ============================
# 10. Jalankan semua Modul
# ============================
echo -e "${GREEN}Jalankan semua Modul...${NC}"
clear && bash module-xray.sh
clear && bash module-ssh.sh
clear && bash module-telegram.sh

# ============================
# 11. Selesai
# ============================
echo -e "${YELLOW}INSTALL SELESAI! Jalankan 'menu' untuk memulai.${NC}"
