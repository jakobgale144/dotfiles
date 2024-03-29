#!/usr/bin/env bash
set -e

# This script assumes: 
# -  Your privileges are already elevated (sudo -i)
# -  This script (and it's associated file, hardware-configuration.nix) lives in /home/root/dotfiles, or just ~/dotfiles

read -p "
Enter the name of the drive NixOS should be installed on (should not be a filepath)
Drive name (example: 'sda'): " DRIVE

# Partitioning the drive
echo "
Making GPT labelspace on /dev/${DRIVE}..."
parted /dev/$DRIVE -- mklabel gpt 1>>/dev/null 2>>/dev/null
echo "Making /dev/${DRIVE}1 (root: btrfs)..."
parted /dev/$DRIVE -- mkpart root btrfs 512MB -8GB 1>>/dev/null 2>>/dev/null
echo "Making /dev/${DRIVE}2 (swap: linux-swap)..."
parted /dev/$DRIVE -- mkpart swap linux-swap -8GB 100% 1>>/dev/null 2>>/dev/null
echo "Making /dev/${DRIVE}3 (boot: fat32)..."
parted /dev/$DRIVE -- mkpart boot fat32 1MB 512MB 1>>/dev/null 2>>/dev/null
echo "Setting /dev/${DRIVE}3 to EFI System Partition..."
parted /dev/$DRIVE -- set 3 esp on 1>>/dev/null 2>>/dev/null

# Making boot and swap filesystems
echo "
Making FAT32 filesystem on /dev/${DRIVE}3..."
mkfs.fat -F 32 -n boot /dev/${DRIVE}3 1>>/dev/null 2>>/dev/null
echo "Making SWAP filesystem on /dev/${DRIVE}2..."
mkswap -L swap /dev/${DRIVE}2 1>>/dev/null 2>>/dev/null
echo "Turning swap on..."
swapon /dev/${DRIVE}2 > /dev/null

# Formatting the main partition with LUKS encryption, making BTRFS filesystem, & creating BTRFS subvolumes
echo "
Formatting /dev/${DRIVE}1 for LUKS encryption..."
cryptsetup --verify-passphrase -v luksFormat /dev/${DRIVE}1
cryptsetup config /dev/${DRIVE}1 --label luksroot
echo "
Opening /dev/${DRIVE}1 into /dev/mapper/crypt..."
cryptsetup open /dev/${DRIVE}1 crypt
echo "
Making BTRFS filesystem on /dev/mapper/crypt..."
mkfs.btrfs -L root /dev/mapper/crypt 1>>/dev/null 2>>/dev/null
echo "Mounting /dev/mapper/crypt..."
mount -t btrfs /dev/mapper/crypt /mnt
echo "
Creating BTRFS subvolumes..."
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
echo "
Creating readonly snapshot of empty root (erase your darlings)..."
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank 1>>/dev/null 2>>/dev/null
echo "Unmounting base subvolume..."
umount /mnt

# Remounting as a collection of BTRFS subvolumes
echo "
Mounting root subvolume..."
mount -o subvol=root,compress=zstd,discard,noatime /dev/mapper/crypt /mnt 
mkdir /mnt/home
echo "Mounting home subvolume..."
mount -o subvol=home,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/home
mkdir /mnt/nix
echo "Mounting nix subvolume..."
mount -o subvol=nix,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/nix
mkdir /mnt/persist
echo "Mounting persist subvolume..."
mount -o subvol=persist,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/persist
mkdir -p /mnt/var/log
echo "Mounting log subvolume..."
mount -o subvol=log,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/var/log
mkdir /mnt/boot

# Mounting boot
echo "
Mounting boot..."
mount /dev/${DRIVE}3 /mnt/boot

# Generating NixOS config files & copying custom hardware config
echo "
Generating NixOS configuration files..."
nixos-generate-config --root /mnt 1>>/dev/null 2>>/dev/null
echo "Copying original hardware config..."
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/BACKUP-hardware-configuration.nix
echo "Moving custom hardware configuration into place..."
cp ~/dotfiles/hardware-configuration.nix /mnt/etc/nixos

echo "
Your default hardware configuration now lives in /mnt/etc/nixos as 'BACKUP-hardware-configuration.nix'.
Compare the two files and see if you need any special parameters included in the custom file.

Edit your configuration files now, and then nixos-install when you are ready."