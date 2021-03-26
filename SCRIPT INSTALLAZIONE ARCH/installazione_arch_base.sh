#!/bin/bash
# Script per installazione Arch di Base
# Author: Gabriele Avi
# Version: 1.0
# The script follows:

echo "Benvenuti nell'installazione di base di Arch Linux con Dual boot!"
read -r -p "Vuoi continuare con l'installazione? [S/n] " response
if [[ ($response) =~ ^([Ss])$ ]] || [ -z ($response) ]]
then
    echo "Sincronizzazione al tempo mondiale..."
    timedatectl -set-ntp true
    echo "Prendendo i mirror più vicini..."
    sleep 2
    reflector --sort-rate -l 15 -p https --save /etc/pacman.d/mirrorlist
    clear
    echo "Visualizzazione partizioni disponibili..."
    fdisk -l
    sleep 10
    echo "Inizio partizionamento disco..."
    read -r -p "Indica per favore il disco: " disk
    cfdisk $disk
    echo "Partizionamento disco avvenuto correttamente!"
    clear
    echo "Segue la formattazione e il montaggio delle partizioni..."
    read -r -p "Indica la partizione della swap: " swap
    mkswap $swap
    swapon $swap
    read -r -p "Indica per favore la partizione del filesystem linux: " filesystem
    mkfs.ext4 $filesystem
    mount $filesystem /mnt
    echo "Creazione directory boot/efi..."
    mkdir -p /mnt/boot/efi
    read -r -p "Indica per favore la partizione boot/efi: " $efi
    mount $efi /mnt/boot/efi
    clear
    echo "installazione dei pacchetti di base con pacstrap!"
    read -r -p "Si selezioni per favore un tipo di kernel linux, linux-lts, linux-zen o linux-hardened: " kernel
    read -r -p "Si selezioni per favore l'editor di testo preferito: " editor
    read -r -p "Si indichi per favore il processore del proprio PC intel o amd?: " processore
    pacstrap /mnt base base-devel $kernel $kernel-headers linux-firmware $editor $processore-ucode 
    echo "Generando le fstab!"
    genfstab -U /mnt >> /mnt/etc/fstab
    echo "Entrando nell'installazione di Arch Linux!"
    arch-chroot /mnt
else
    echo "Operazione annullata, grazie per aver utilizzato il nostro script!"
fi

