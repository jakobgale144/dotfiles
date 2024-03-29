#!/usr/bin/env bash
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart root btrfs 512MB -8GB
parted /dev/vda -- mkpart swap linux-swap -8GB 100%
parted /dev/vda -- mkpart boot fat32 1MB 512MB
parted /dev/vda -- set 3 esp on
mkfs.fat -F 32 -n boot /dev/vda3
mkswap -L swap /dev/vda2
swapon /dev/vda2
cryptsetup --verify-passphrase -v luksFormat /dev/vda1
cryptsetup open /dev/vda1 crypt
mkfs.btrfs -L root /dev/mapper/crypt
mount -t btrfs /dev/mapper/crypt /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt
echo "Mounting root..."
mount -o subvol=root,compress=zstd,discard,noatime /dev/mapper/crypt /mnt 
mkdir /mnt/home
echo "Mounting home..."
mount -o subvol=home,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/home
mkdir /mnt/nix
echo "Mounting nix..."
mount -o subvol=nix,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/nix
mkdir /mnt/persist
echo "Mounting persist..."
mount -o subvol=persist,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/persist
mkdir -p /mnt/var/log
echo "Mounting log..."
mount -o subvol=log,compress=zstd,discard,noatime /dev/mapper/crypt /mnt/var/log
mkdir /mnt/boot
echo "Mounting boot..."
mount /dev/vda3 /mnt/boot
nixos-generate-config --root /mnt
