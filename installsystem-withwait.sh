parted /dev/sda -- mklabel
parted /dev/sda -- mkpart root btrfs 512MB -8GB
parted /dev/sda -- mkpart swap linux-swap -8GB 100%
parted /dev/sda -- mkpart boot fat32 1MB 512MB
parted /dev/sda -- set 3 esp
mkfs.fat -F 32 -n boot /dev/sda3
sleep 5
mkswap -L swap /dev/sda2
sleep 5
swapon /dev/sda2
sleep 5
cryptsetup --verify-passphrase -v luksFormat /dev/sda1
sleep 5
cryptsetup open /dev/sda1 crypt
sleep 5
mkfs.btrfs -L root /dev/mapper/crypt
sleep 5
mount -t btrfs /dev/mapper/crypt /mnt
sleep 5
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
sleep 5
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
sleep 5
umount /mnt
sleep 5
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
sleep 5
mount -L boot /dev/sda3 /mnt/boot
sleep 5