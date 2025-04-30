#!/bin/bash

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan menu dan mendapatkan pilihan pengguna
display_menu() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${YELLOW}Pilih Versi Windows atau Sistem Operasi:${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo "1. Windows 7 Enterprise"
    echo "2. Windows Server 2019"
    echo "3. Windows Server 2022 new.."
    echo "4. Windows Server 2016"
    echo "5. Ubuntu 20.04 LTS"
    echo "6. Windows 11 IoT LTSC"
    echo "7. Windows Server 2025"
    echo "8. Windows Server 2012 R2"
    echo "9. Windows 8.1 Pro"
    echo "10. Windows 10 Pro"
    echo "11. Windows 11 Pro"
    echo "12. Windows XP Professional"
    echo "13. Windows Vista Business"
    read -p "$(echo -e ${GREEN}Masukkan pilihan Anda [1-13]: ${NC})" choice
}

# Memperbarui repositori paket dan menginstal dependensi
echo -e "${YELLOW}Memperbarui repositori paket...${NC}"
apt-get update -y || { echo -e "${RED}Gagal memperbarui repositori paket!${NC}"; exit 1; }

echo -e "${YELLOW}Menginstal Apache2...${NC}"
apt install apache2 -y || { echo -e "${RED}Gagal menginstal Apache2!${NC}"; exit 1; }
sudo ufw allow 'Apache' && echo -e "${GREEN}Apache diizinkan di firewall.${NC}"

# Menginstal QEMU, screen, dan utilitasnya
echo -e "${YELLOW}Menginstal QEMU, screen, dan dependensi...${NC}"
apt-get install -y qemu qemu-utils qemu-system-x86-64 qemu-kvm screen || { echo -e "${RED}Gagal menginstal QEMU atau screen!${NC}"; exit 1; }
echo -e "${GREEN}Instalasi QEMU dan screen selesai.${NC}"

# Mendapatkan pilihan pengguna
display_menu

# Menentukan file image dan tautan ISO berdasarkan pilihan
case $choice in
    1)
        # Windows 7 Enterprise
        img_file="win7.img"
        iso_link="https://software-static.download.prss.microsoft.com/dbazure/en_windows_7_enterprise_with_sp1_x64_dvd_u_677651.iso"
        iso_file="win7.iso"
        ;;
    2)
        # Windows Server 2019
        img_file="win2019.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195167&clcid=0x409&culture=en-us&country=US"
        iso_file="win2019.iso"
        ;;
    3)
        # Windows Server 2022
        img_file="win2022.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195280&clcid=0x409&culture=en-us&country=US"
        iso_file="win2022.iso"
        ;;
    4)
        # Windows Server 2016
        img_file="win2016.img"
        iso_link="https://go.microsoft.com/fwlink/p/?linkid=2195684&clcid=0x409&culture=en-us&country=us"
        iso_file="win2016.iso"
        ;;
    5)
        # Ubuntu 20.04 LTS
        img_file="ubuntu20.img"
        iso_link="https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso"
        iso_file="ubuntu20.iso"
        ;;
    6)
        # Windows 11 IoT LTSC
        img_file="win11ltsc.img"
        iso_link="https://software-static.download.prss.microsoft.com/dbazure/26100.1.240331-1435.ge_release_CLIENT_IOT_LTSC_EVAL_x64FRE_en-us.iso"
        iso_file="win11ltsc.iso"
        ;;
    7)
        # Windows Server 2025
        img_file="win2025.img"
        iso_link="https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us"
        iso_file="win2025.iso"
        ;;
    8)
        # Windows Server 2012 R2
        img_file="win2012r2.img"
        iso_link="https://go.microsoft.com/fwlink/p/?LinkID=2195443&clcid=0x409&culture=en-us&country=US"
        iso_file="win2012r2.iso"
        ;;
    9)
        # Windows 8.1 Pro
        img_file="win81.img"
        iso_link="https://software-static.download.prss.microsoft.com/dbazure/en_windows_8.1_pro_vl_with_update_x64_dvd_6051500.iso"
        iso_file="win81.iso"
        ;;
    10)
        # Windows 10 Pro
        img_file="win10.img"
        iso_link="https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64v1.iso"
        iso_file="win10.iso"
        ;;
    11)
        # Windows 11 Pro
        img_file="win11.img"
        iso_link="https://software.download.prss.microsoft.com/dbazure/Win11_23H2_English_x64v2.iso"
        iso_file="win11.iso"
        ;;
    12)
        # Windows XP Professional
        img_file="winxp.img"
        iso_link="https://software-static.download.prss.microsoft.com/dbazure/en_windows_xp_professional_with_sp3_x86_dvd.iso"
        iso_file="winxp.iso"
        ;;
    13)
        # Windows Vista Business
        img_file="vista.img"
        iso_link="https://software-static.download.prss.microsoft.com/dbazure/en_windows_vista_business_x64_dvd.iso"
        iso_file="vista.iso"
        ;;
    *)
        echo -e "${RED}Pilihan tidak valid. Keluar.${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}Versi yang dipilih: $img_file${NC}"

# Membuat file image raw
echo -e "${YELLOW}Membuat file image $img_file...${NC}"
qemu-img create -f raw "$img_file" 30G || { echo -e "${RED}Gagal membuat file image!${NC}"; exit 1; }
echo -e "${GREEN}File image $img_file berhasil dibuat.${NC}"

# Mengunduh Virtio driver ISO
echo -e "${YELLOW}Mengunduh Virtio driver ISO...${NC}"
wget -O virtio-win.iso 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso' || { echo -e "${RED}Gagal mengunduh Virtio driver ISO!${NC}"; exit 1; }
echo -e "${GREEN}Virtio driver ISO berhasil diunduh.${NC}"

# Mengunduh ISO Windows
echo -e "${YELLOW}Mengunduh ISO: $iso_file...${NC}"
wget -O "$iso_file" "$iso_link" || { echo -e "${RED}Gagal mengunduh ISO Windows!${NC}"; exit 1; }
echo -e "${GREEN}ISO Windows berhasil diunduh.${NC}"

# Menjalankan QEMU secara otomatis di screen
echo -e "${YELLOW}Menjalankan QEMU di sesi screen untuk $img_file...${NC}"
screen -dmS qemu qemu-system-x86_64 \
    -m 6G \
    -cpu host \
    -enable-kvm \
    -smp 4 \
    -boot order=d \
    -drive file="$iso_file",media=cdrom \
    -drive file="$img_file",format=raw,if=virtio \
    -drive file=virtio-win.iso,media=cdrom \
    -device usb-ehci,id=usb,bus=pci.0,addr=0x4 \
    -device usb-tablet \
    -vnc :0 || { echo -e "${RED}Gagal menjalankan QEMU!${NC}"; exit 1; }
echo -e "${GREEN}QEMU telah dijalankan di sesi screen bernama 'qemu'.${NC}"
echo -e "${YELLOW}Gunakan 'screen -r qemu' untuk melihat sesi, atau akses VNC di port :0.${NC}"
