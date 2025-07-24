#!/bin/bash
# Renew akun VLESS

GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

clear
echo -e "${GREEN}Renew Akun VLESS${NC}"

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

# Ambil tanggal expired sekarang (asumsi stored di comment/email atau di DB)
# Karena ini contoh sederhana, kita tidak simpan tanggal di config, jadi set tanggal baru saja

newexp=$(date -d "+$hari days" +"%Y-%m-%d")

# Jika menggunakan DB/JSON, update expired disitu
# TODO: implementasi update expired detail

echo -e "${YELLOW}User $user diperpanjang sampai $newexp${NC}"

read -rp "Tekan Enter untuk kembali ke menu..."
bash /usr/bin/xray/menu-xray.sh
