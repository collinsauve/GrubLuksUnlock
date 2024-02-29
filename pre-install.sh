#/usr/bin/env bash
set -euo pipefail

root_dev=/dev/nvme0n1p2

# Format partitions
cryptsetup luksFormat --type=luks1 -v $root_dev

# Now let's open the partitions
cryptsetup open --type=luks1 -v $root_dev EncryptedUbuntuRoot

# Now that the partitions are open, let's create the lvm on the main partition:
mkfs.ext4 /dev/mapper/EncryptedUbuntuBoot -L "boot"

# Now all the partitions are according to what we want, let's install ubuntu:
ubiquity --no-bootloader
