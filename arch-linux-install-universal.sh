#!/bin/bash
# Author: Gabriele Avi
# Version : 0.1
# Description: A bash script that installs arch linux for you, when you chrooted! !ATTENTION! It has bash as bootloader!
# Creation date: 19/04/2021
# Script starts here:
echo "Welcome to the Universal Arch Linux Install Script!"
read -r -p "Do you wish to continue? [Y/n] " response
if [[ "$response" =~ ^([Yy])$ ]] || [[ -z $response ]]
then
        echo "Starting the installation script!"
    sleep 2
    read -r -p "Which keyboard do you use?
    -en_us
    -en_gb
    -other languages (Check the wiki!) " keyboard
    loadkeys $keyboard
    read -r -p "In which path did you mount your EFI partiton? (e.g. /boot/efi/) " efi
    read -r -p "Which name do you want to assing to your user? " user
    read -r -p "Which text editor did you install in the base install? " editor
    read -r -p "Which browser do you wish to install? The options are:
    - firefox
    - chromium
    - falkon
    - qtbrowser
    - vivaldi
    (insert the name)" browser
    read -r -p "Which desktop environment/window manager, do you wish to install? The choices are:
    - gnome
    - xfce
    - plasma
    - mate
    - lxqt
    - enlightenment
    - bspwm
    - i3
    - xmonad
    - qtile
    - sway 
    (insert the name) " de
    read -r -p "Which display manager (DM) do you want to use?
    -gdm
    -sddm
    -lightdm
    -lxdm
    -xdm
    (insert name) " dm
    read -r -p "Which audio package do you wish to install?
    - pulseaudio
    - pipewire 
    (insert the name) " audio
    read -r -p "Which terminal do you like to use?
    - gnome-terminal
    - konsole
    - alacritty
    - termite
    - terminator
    - xfce4-terminal
    - mate-terminal (insert name)" terminal
    read -r -p "Which linux kernel did you choose?
    -linux
    -linux-lts
    -linux-hardened
    -linux-zen
    (insert name) " kernel
        clear
        echo "Setting the local time and syncronising with the hardware clock..."
        read -r -p "Please write an available time zone (e.g. Europe/Rome): " time
        ln -sf /usr/share/zoneinfo/$time
        hwclock --systohc
        sleep 3
        echo "Setting the locales..."
        sleep 2
        echo "Please choose a locale or multiple locales from the locale.gen file (you will be redirected with the editor you chose before)"
        sleep 8
        $editor /etc/locale.gen
        locale-gen
        read -r -p "Please insert the chosen locale (e.g. it_IT.UTF-8) " locale
        sleep 3
        echo LANG=$locale >> /etc/locale.conf
            echo "Adding the keyboard layout to /etc/vconsole.conf ..."
            sleep 3
            echo KEYMAP=$keyboard >> /etc/vconsole.conf
            read -r -p "Please enter the hostname: " hostname
            echo "Adding hostname to /etc/hostname..."
            sleep 3
            echo "$hostname" >> /etc/hostname
            echo "Please insert the loopback IP adresses for localhost and the local domain the the /etc/hosts file"
            sleep 3
            $editor /etc/hosts
            echo "Edit the root user password"
            sleep 3
            passwd root

            clear
            echo "Installing the packages you chose before..."
            sleep 4
                if [[ "$dm" = lightdm ]]; then
                    pacman -S grub efibootmgr os-prober $terminal cups networkmanager network-manager-applet dialog mtools dosfstools ntfs-3g $kernel-headers base-devel xorg $de $browser $audio $dm lightdm-gtk-greeter git reflector bluez bluez-utils xdg-utils xdg-user-dirs
                    grub-install --target=x86_64-efi --efi-directory=$efi --bootloader-id=GRUB
                    grub-mkconfig -o /boot/grub/grub.cfg
                    systemctl enable NetworkManager
                    systemctl enable bluetooth
                    systemctl enable cups
                    systemctl enable $dm
                    echo "Adding a system user..."
                    sleep 2
                    useradd -mG wheel $user
                    passwd $user
                    clear
                    echo "Now you will be redirected in the visudo command, if you don't want to assign superuser privileges to your user, just exit! "
                    EDITOR=$editor visudo
                    clear
                    echo "The script ended successfully! You may now exit the root, unmount all your partitions with umount -a and then reboot the computer!"
                else
                    pacman -S grub efibootmgr os-prober $terminal cups networkmanager network-manager-applet dialog mtools dosfstools ntfs-3g $kernel-headers base-devel xorg $de $browser $audio $dm git reflector bluez-utils bluez xdg-utils xdg-user-dirs
                echo "Installing grub bootloader..."
                sleep 6
                grub-install --target=x86_64-efi --efi-directory=$efi --bootloader-id=GRUB
                echo "Generating GRUB configuration file..."
                sleep 5
                grub-mkconfig -o /boot/grub/grub.cfg
                systemctl enable NetworkManager
                systemctl enable bluetooth
                systemctl enable cups
                systemctl enable $dm
                echo "Adding a system user..."
                sleep 5
                useradd -mG wheel $user
                passwd $user
                echo "Giving sudo privileges at your account (if you don't want to give root priviliges, exit the text editor..."
                sleep 10
                EDITOR=$editor visudo
                echo "You finished your Arch Linux Install! Now reboot your system!"
                fi
            else
            echo "Operazione annullata!"
                fi
