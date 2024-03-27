#! /bin/sh
sudo -i
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart root btrfs 512MB -8GB
parted /dev/vda -- mkpart swap linux-swap -8GB 100%
parted /dev/vda -- mkpart boot fat32 1MB 512MB
parted /dev/vda -- set 3 esp on
mkfs.fat -F 32 -n boot /dev/sda3
mkswap -L swap /dev/sda2
swapon /dev/sda2
cryptsetup --verify-passphrase -v luksFormat /dev/sda1
YES
atgalenegwearesecure
cryptsetup open /dev/sda1 crypt
atgalenegwearesecure
mkfs.btrfs -L root /dev/mapper/crypt
mount -t btrfs /dev/mapper/crypt /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt
mount -o subvol=root,compress=zstd,autodefrag,discard,noatime /dev/mapper/crypt /mnt 
mkdir /mnt/home
mount -o subvol=home,compress=zstd,autodefrag,discard,noatime /dev/mapper/crypt /mnt/home
mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,autodefrag,discard,noatime /dev/mapper/crypt /mnt/nix
mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,autodefrag,discard,noatime /dev/mapper/crypt /mnt/persist
mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,autodefrag,discard,noatime /dev/mapper/crypt /mnt/var/log
mkdir /mnt/boot
mount -L boot /dev/sda3 /mnt/boot