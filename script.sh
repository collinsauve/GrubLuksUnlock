#/usr/bin/env bash

boot_dev=/dev/nvme0n1p2
root_dev=/dev/nvme0n1p3

# Format partitions
cryptsetup luksFormat --type=luks1 -v $boot_dev
cryptsetup luksFormat --type=luks2 -v $root_dev

# Now let's open the partitions
cryptsetup open --type=luks1 -v $boot_dev EncryptedUbuntuBoot
cryptsetup open --type=luks2 -v /dev/nvme0n1p6 EncryptedUbuntuLVM

# Now that the partitions are open, let's create the lvm on the main partition:
pvcreate /dev/mapper/EncryptedUbuntuLVM
vgcreate UbuntuVG /dev/mapper/EncryptedUbuntuLVM

lvcreate -L16G UbuntuVG -n swap
lvcreate -L60G UbuntuVG -n root
lvcreate -L4G UbuntuVG -n tmp
lvcreate -L4G UbuntuVG -n var
lvcreate -L4G UbuntuVG -n var_log
lvcreate -L4G UbuntuVG -n var_tmp
lvcreate -l 100%FREE UbuntuVG -n home

# Now lets format the partitions, i always go for ext4
# Feel free to chose what you like for your partitions:
mkfs.ext4 /dev/mapper/UbuntuVG-root -L "root"
mkfs.ext4 /dev/mapper/UbuntuVG-home -L "home"
mkfs.ext4 /dev/mapper/UbuntuVG-tmp -L "tmp"
mkfs.ext4 /dev/mapper/UbuntuVG-var -L "var"
mkfs.ext4 /dev/mapper/UbuntuVG-var_log -L "var_log"
mkfs.ext4 /dev/mapper/UbuntuVG-var_tmp -L "var_tmp"
mkfs.ext4 /dev/mapper/EncryptedUbuntuBoot -L "boot"

# Now all the partitions are according to what we want, let's install ubuntu: