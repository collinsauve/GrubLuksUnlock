#/usr/bin/env bash
set -euo pipefail

root_dev=/dev/nvme0n1p2
mkdir -p /etc/luks
dd if=/dev/urandom of=/etc/luks/Root.keyfile bs=4096 count=1

chmod u=rx,go-rwx /etc/luks
chmod u=r,go-rwx /etc/luks/Root.keyfile
cryptsetup luksAddKey $root_dev /etc/luks/Root.keyfile
cryptsetup luksDump $root_dev

# nano /etc/cryptsetup-initramfs/conf-hook
#
# at the end of the file uncomment add:
# KEYFILE_PATTERN=/etc/luks/*.keyfile

# nano /etc/initramfs-tools/initramfs.conf
#
# At the end of the file add:
# UMASK=0077

# nano /etc/crypttab
#
# Add:
# EncryptedUbuntuRoot /dev/nvme0n1p2 /etc/luks/Root.keyfile luks


apt install grub-efi-amd64 mtools os-prober efibootmgr

# nano /etc/default/grub
#
# Change this setting:
# GRUB_CMDLINE_LINUX_DEFAULT=""
#
# Add:
# GRUB_ENABLE_CRYPTODISK=y
# GRUB_CMDLINE_LINUX="efi=noruntime pcie_-ports=compat acpi=force"
# GRUB_HIDDEN_TIMEOUT=5
# GRUB_TIMEOUT_STYLE=menu

apt install -y --reinstall grub-efi-amd64 mtools os-prober efibootmgr

update-initramfs -c -k all

grub-install /dev/nvme0n1

update-grub



