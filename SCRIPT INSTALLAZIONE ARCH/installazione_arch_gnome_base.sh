#!/bin/bash

# Author: Gabriele Avi
# Version: 1.0
# Script follows:

ln -sf /usr/zoneinfo/Europe/Rome /etc/locatime
hwclock --systohc
echo "Impostando le localizzazioni..."
read -r -p "Indicare l'editor installato nella fase precedente: " editor
$editor /etc/locale.gen
locale-gen
$editor /etc/locale.conf
echo "Indicare la tastiera in uso..."
$editor /etc/vconsole.conf
echo "Impostare hostname..."
$editor /etc/hostname
echo "Impostare gli hosts..."
$editor /etc/hosts
echo "Installando i pacchetti del sistema con pacman..."
read -r -p "Impostare un browser di preferenza tra firefox e chromium: " browser
pacman -S grub efibootmgr os-prober $browser bluez bluez-utils alsa-utils pulseaudio pulseaudio-bluetooth mtools dialog xdg-utils xdg-user-dirs networkmanager network-manager-applet cups git reflector gnome gnome-extra
echo "Configurazione grub..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
echo "Generazione file di configurazione grub..."
grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo "Attivando i servizi all'avvio..."
systemctl enable NetworkManager
systemctl enable cups
systemctl enable bluetooth
systemctl enable gdm
echo "Cambio password all'utente root..."
passwd root
echo "Creazione nuovo utente..."
read -r -p "Inserire il nome utente: " nome
useradd -mG wheel $nome
echo "Ora scegli una password per il tuo account..."
passwd $nome
echo "Configurazione sudo per l'account creato, togli il commento a %wheel ALL=(ALL) ALL"
EDITOR=$editor visudo
clear
echo "Configurazione del sistema completata per favore riavvia il computer, ricordati di uscire dall'ambiente root e fare umount -a!"
