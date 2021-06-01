# Arch linux install script written in Python
# Author : Gabriele Avi
# Version : 0.0.1
# Creation date : 31 May 2021
# Code begins here

import datetime
import os
import time

def arch_install_iso():
    print("Welcome to the Arch Linux Install script! It will guide you through all the process to have a complete system working!")
    confirm = input("Do you want to start the script? Write 'yes' if you want to do so: ")
    if confirm == "yes" or confirm == "Yes" or confirm == "YES":
        print("Script will start in ", end="")
        for i in range(3, 0, -1):
            print(i, end="...")
            time.sleep(1)
        print("now!")
        # User input of preferred packages
        ker = input("""Please choose the desired kernel:
        1. linux
        2. linux-lts
        3. linux-hardened
        4. linux-zen
        (input the full name): """)
        texed = input("""Please choose a text editor:
        1. nano
        2. vim
        3. neovim
        4. vi
        (input the full name): """)
        name = input("Insert the username for your account: ")
        host = input("Please put your desired hostname: ")
        network1, network2, network3 = "127.0.0.1   localhost", "::1    localhost", str("127.0.1.1  {}.localdomain  {}" .format(host, host))
        tz = input("Please insert your time zone from the Arch Wiki (e.g. Europe/Rome): ")
        loc = input("Please input your locale, checking in the Wiki if you don't know it (e.g. en_US.UTF-8): ")
        # Keyboard setup
        kb = input("Which keyboard do you use? Please insert it, according to Arch Linux's Official Wiki (e.g. en_us): ")
        os.system("loadkeys {}" .format(kb))
        # Verifying network connection
        network = input("Do you have an Internet connection ready? [y/n] ")
        if network == "Y" or network == "y":
            # Sincronising the time with Internet
            os.system("timedatectl set-ntp true")
            # Updating the mirrors with reflector
            os.system("reflector --sort rate -p https -l 10 --save /etc/pacman.d/mirrorlist")
            os.system("pacman -Syy")
        else:
            wcn = input("Do you want to configure wireless network? [y/n] ")
            if wcn == "y" or wcn == "Y":
                print("""You will be redirected to iwctl to configure your wireless network, use 'station NameOfTheStation get-networks' to get existing networks
                and then 'station NameOfTheStation connect NameOfTheNetwork' to connect to the network""")
                time.sleep(5)
                os.system("iwctl")
        print("Now you will need to configure the disk:")
        os.system("fdisk -l")
        time.sleep(5)
        part = input("Select the desired disk you want to partition (e.g. /dev/sda) ")
        print("Partitioning the drive...")
        print("Creating a EFI partition in the disk...")
        # Using parted to partition the drives
        os.system("parted {} mklabel gpt mkpart fat32 1MiB 200MiB" .format(part))
        os.system("parted {} mkpart linux-swap 200MiB 4GiB" .format(part))
        os.system("parted {} mkpart ext4 4GiB 100%" .format(part))
        print("Mounting the partitions...")
        # Formatting the file systems
        os.system("mkfs.fat -F32 {}1" .format(part))
        os.system("mkswap {}2" .format(part))
        os.system("swapon {}2" .format(part))
        os.system("mkfs.ext4 {}3" .format(part))
        # Mounting the partitions
        os.system("mount {}3 /mnt" .format(part))
        os.system("mkdir -p /mnt/boot/efi")
        os.system("mount {}1 /mnt/boot/efi")
        # Installing the base packages
        os.system("clear")
        print("Now the script will install the base packages with pacstrap")
        time.sleep(3)
        os.system("pacstrap /mnt base {0} linux-firmware {1}" .format(ker, texed))
        # Generating the fstab
        os.system("genfstab -U /mnt >> /mnt/etc/fstab")
        # Chrooting
        os.system("arch-chroot /mnt")
        # Setting the local time and sincronizing the hardware clock to the system clock
        print("Now the script will configure the local time...")
        os.system("ln -sf /usr/share/zoneinfo/{} /etc/localtime" .format(tz))
        os.system("hwclock --systohc")
        print("Now you will be redirected to the /etc/locale.gen file, select the system locale!")
        time.sleep(5)
        # Setting up the locales
        os.system("{} /etc/locale.gen" .format(texed))
        print("Generating the locales...")
        os.system("locale-gen")
        os.system("echo LANG={} /etc/locale.conf" .format(loc))
        os.system("echo KEYMAP={} /etc/vconsole.conf" .format(kb))
        # Setting the hostname and the network file
        os.system("echo {} /etc/hostname" .format(host))
        os.system("echo {} /etc/hosts" .format(network1))
        os.system("echo {} /etc/hosts" .format(network2))
        os.system("echo {} /etc/hosts" .format(network3))        
        # Setting the root password
        rootpsw = input("Now you can input the root password... do you want to do it? [y/n] ")
        if rootpsw == "y" or rootpsw == "Y":
            os.system("passwd")
        # Installing the other part of the system
        print("Now the script will install the rest of the system, with the bootloader, etc...")
        time.sleep(2)
        os.system("pacman --noconfirm -S grub efibootmgr os-prober networkmanager network-manager-applet dialog mtools dosfstools ntfs-3g base-devel {}-headers bluez bluez-utils alsa-utils pulseaudio pulseaudio-bluetooth cups git reflector xdg-utils xdg-user-dirs" .format(ker))
        # Installing the bootloader
        print("Now the script will install the GRUB bootloader...")
        time.sleep(3)
        os.system("grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB")
        os.system("grub-mkconfig -o /boot/grub/grub.cfg")
        # Activating the services
        print("Now the different services will be activated using systemctl")
        time.sleep(2)
        os.system("systemctl enable NetworkManager")
        os.system("systemctl enable bluetooth")
        os.system("systemctl enable cups")
        # Setting up the user
        os.system("useradd -mG wheel {}" .format(name))
        print("Now you will be redirected to the sudoers file, if you want to give the new account sudo privileges, you can do it now...")
        time.sleep(3)
        os.system("EDITOR={} visudo" .format(texed))
        print("Now the installation is complete, you will need to reboot, after you exited the chroot and umounted all the partition with 'umount -a' ")
        time.sleep(2)
    print("Thank you for using this script!")
if __name__ == '__main__':
    arch_install_iso