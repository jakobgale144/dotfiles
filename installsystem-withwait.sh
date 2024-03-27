#!/usr/bin/env bash
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root btrfs 512MB -8GB
parted /dev/sda -- mkpart swap linux-swap -8GB 100%
parted /dev/sda -- mkpart boot fat32 1MB 512MB
parted /dev/sda -- set 3 esp on
mkfs.fat -F 32 -n boot /dev/sda3
sleep 5s
mkswap -L swap /dev/sda2
sleep 5s
swapon /dev/sda2
sleep 5s
cryptsetup --verify-passphrase -v luksFormat /dev/sda1
sleep 5s
cryptsetup open /dev/sda1 crypt
sleep 5s
mkfs.btrfs -L root /dev/mapper/crypt
sleep 5s
mount -t btrfs /dev/mapper/crypt /mnt
sleep 5s
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
sleep 5s
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
sleep 5s
umount /mnt
sleep 5s
mount -o subvol=root,compress=zstd,discard,noatime /dev/mapper/crypt /mnt 
mkdir /mnt/home
mount -o subvol=home,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/home
mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/nix
mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/persist
mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/var/log
mkdir /mnt/boot
sleep 5s
mount -L boot /dev/sda3 /mnt/boot
sleep 5s