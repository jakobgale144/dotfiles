#!/bin/sh
cryptsetup luksOpen /dev/nvme0n1p2 crypt
mkdir /mnt/{nix,temp,persist,snapshots,swap,boot}
mount -o compress-force=zstd:1,relatime,subvol=@nix /dev/mapper/crypt /mnt/nix
mount -o compress-force=zstd:1,relatime,subvol=@temp /dev/mapper/crypt /mnt/temp
mount -o compress-force=zstd:1,relatime,subvol=@persist /dev/mapper/crypt /mnt/persist
mount -o compress-force=zstd:1,relatime,subvol=@snapshots /dev/mapper/crypt /mnt/snapshots
mount -o subvol=@swap /dev/mapper/crypt /mnt/swap
mount /dev/nvme0n1p1 /mnt/boot
swapon /mnt/swap/swapfile
