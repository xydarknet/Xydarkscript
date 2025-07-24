#!/bin/bash
# Update semua script dari repo utama

cd /usr/bin/xray || exit 1

echo "Update script dari repo Xydarkscript..."
wget -q -O menu-xray.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/menu-xray.sh
wget -q -O addvless.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/addvless.sh
wget -q -O addtrojan.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/addtrojan.sh
wget -q -O ceklog.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/ceklog.sh
wget -q -O renewvless.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/renewvless.sh
wget -q -O renewtrojan.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/renewtrojan.sh
wget -q -O delvless.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/delvless.sh
wget -q -O deltrojan.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/deltrojan.sh
wget -q -O uuidvless.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/uuidvless.sh
wget -q -O uuidtrojan.sh https://raw.githubusercontent.com/xydarknet/Xydarkscript/main/xray/uuidtrojan.sh

chmod +x *.sh

echo "Update selesai."
