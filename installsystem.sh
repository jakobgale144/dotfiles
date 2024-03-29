#!/usr/bin/env bash

# This script assumes: 
# -  Your privileges are already elevated (sudo -i)
# -  This script (and it's associated file, hardware-configuration.nix) lives in /home/root/dotfiles, or just ~/dotfiles

# Partitioning the drive
echo "Making GPT labelspace on /dev/sda..."
parted /dev/sda -- mklabel gpt 1>>/dev/null 2>>/dev/null
echo "Making /dev/sda1 (root: btrfs)..."
parted /dev/sda -- mkpart root btrfs 512MB -8GB 1>>/dev/null 2>>/dev/null
echo "Making /dev/sda2 (swap: linux-swap)..."
parted /dev/sda -- mkpart swap linux-swap -8GB 100% 1>>/dev/null 2>>/dev/null
echo "Making /dev/sda3 (boot: fat32)..."
parted /dev/sda -- mkpart boot fat32 1MB 512MB 1>>/dev/null 2>>/dev/null
echo "Setting /dev/sda3 to EFI System Partition..."
parted /dev/sda -- set 3 esp on 1>>/dev/null 2>>/dev/null

# Making boot and swap filesystems
echo "Making Fat32 filesystem on /dev/sda3..."
mkfs.fat -q -F 32 -n boot /dev/sda3
echo "Making SWAP filesystem on /dev/sda2..."
mkswap -L swap /dev/sda2 > /dev/null
echo "Turning swap on..."
swapon /dev/sda2 > /dev/null

# Formatting the main partition with LUKS encryption, making BTRFS filesystem, & creating BTRFS subvolumes
echo "Formatting /dev/sda1 for LUKS encryption..."
cryptsetup --verify-passphrase -v luksFormat /dev/sda1
echo "Opening /dev/sda1 into /dev/mapper/crypt..."
cryptsetup open /dev/sda1 crypt
echo "Making BTRFS filesystem on /dev/mapper/crypt..."
mkfs.btrfs -q -L root /dev/mapper/crypt
echo "Mounting /dev/mapper/crypt..."
mount -t btrfs /dev/mapper/crypt /mnt
echo "Creating BTRFS subvolumes..."
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
echo "Creating readonly snapshot of empty root (erase your darlings)..."
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank > /dev/null
echo "Unmounting base subvolume..."
umount /mnt

# Remounting as a collection of BTRFS subvolumes
echo "Mounting root subvolume..."
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
echo "Mounting boot..."
mount /dev/sda3 /mnt/boot

# Generating NixOS config files & copying custom hardware config
# echo "Generating NixOS configuration files..."
nixos-generate-config --root /mnt
echo "Copying original hardware config..."
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/BACKUP-hardware-configuration.nix
echo "Moving custom hardware configuration into place..."
cp ~/dotfiles/hardware-configuration.nix /mnt/etc/nixos

echo "Edit your configuration files now, and then nixos-install when you are ready."