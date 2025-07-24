#!/bin/bash

# ◦•●◉✿ FINAL INSTALL SCRIPT by xydark ✿◉●•◦
# Telegram: t.me/xydark
# Info: Auto setup tunneling server + Xray WS + gRPC + SSH + Telegram Notify

# ============================
# 01. Warna
# ============================
GREEN="\e[92m" YELLOW="\e[93m" RED="\e[91m" NC="\e[0m"

# ============================
# 02. Auto Permission IP
# ============================
echo -e "${GREEN}Cek izin IP server...${NC}"
MYIP=$(curl -s ipv4.icanhazip.com)
IZIN=$(curl -s https://raw.githubusercontent.com/xydarknet/izin/main/allow | grep "$MYIP")

if [[ $MYIP == "$IZIN" ]]; then
    echo -e "${YELLOW}Akses Diterima untuk IP: $MYIP${NC}"
else
    echo -e "${RED}IP $MYIP tidak diizinkan. Silakan minta izin ke t.me/xydark.${NC}"
    exit 1
fi

# ============================
# 03. Banner ASCII "X" (/etc/issue.net)
# ============================
echo -e "${GREEN}Setup Banner SSH...${NC}"
cat << EOF > /etc/issue.net
██╗  ██╗
╚██╗██╔╝
 ╚███╔╝ 
 ██╔██╗ 
██╔╝ ██╗
╚═╝  ╚═╝   by xydark
t.me/xydark - SSH Access
EOF

sed -i 's|#Banner none|Banner /etc/issue.net|' /etc/ssh/sshd_config
systemctl restart sshd

# ============================
# 04. IPTables Legacy Mode
# ============================
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# ============================
# 05. Disable IPv6
# ============================
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p > /dev/null

# ============================
# 06. Setup Domain (Manual/Random)
# ============================
echo -e "${GREEN}Setup Domain Server...${NC}"
read -rp "Masukkan domain Anda (kosongkan untuk random): " host_input
if [[ -z $host_input ]]; then
    sub=$(</dev/urandom tr -dc a-z0-9 | head -c5)
    domain="$sub.xydark.my.id"
    echo -e "${YELLOW}Domain kosong, menggunakan domain otomatis: $domain${NC}"
else
    domain="$host_input"
    echo -e "${YELLOW}Menggunakan domain Anda: $domain${NC}"
fi
echo "$domain" > /etc/xray/domain
hostnamectl set-hostname "$domain"
echo -e "${GREEN}Domain tersimpan di /etc/xray/domain${NC}"

# ============================
# 07. Fail2Ban & Firewall (UFW)
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
# 08. Struktur Folder Modular
# ============================
echo -e "${GREEN}Setup Struktur Folder...${NC}"
mkdir -p /etc/xray/{config,log,limit,uuid}
mkdir -p /etc/ssh/{config,limit}
mkdir -p /etc/telegram

# ============================
# 09. Install Dependency
# ============================
echo -e "${GREEN}Install Package Wajib...${NC}"
apt update -y && apt upgrade -y
apt install curl socat cron bash-completion wget unzip jq net-tools iptables-persistent -y

# ============================
# 10. Install Xray-Core
# ============================
echo -e "${GREEN}Installing Xray-Core...${NC}"
mkdir -p /usr/local/bin/xray
curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip
unzip -oq xray.zip -d /usr/local/bin/xray
chmod +x /usr/local/bin/xray/xray
rm -f xray.zip

# ============================
# 11. Setup Telegram BOT
# ============================
echo -e "${GREEN}Setup Telegram Notifikasi...${NC}"
BOT_TOKEN="7986904946:AAGdeQpLTROH0vrjDR2gj3HGlmc2fb5ijkw"
CHAT_ID="-4939887004"
echo "$BOT_TOKEN" > /etc/telegram/bot_token
echo "$CHAT_ID" > /etc/telegram/chat_id

# ============================
# 12. Download Script Modular
# ============================
echo -e "${GREEN}Download Modular Script...${NC}"
cd /usr/bin || exit
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-xray.sh -O module-xray.sh
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-ssh.sh -O module-ssh.sh
wget -q https://raw.githubusercontent.com/xydarknet/autotunnel/main/module-telegram.sh -O module-telegram.sh
chmod +x module-*.sh

# ============================
# 13. Jalankan Modul
# ============================
echo -e "${GREEN}Jalankan semua Modul...${NC}"
clear && bash module-xray.sh
clear && bash module-ssh.sh
clear && bash module-telegram.sh

# ============================
# 14. Selesai
# ============================
echo -e "${YELLOW}INSTALL SELESAI! Jalankan perintah 'menu' untuk memulai.${NC}"
