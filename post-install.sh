#/usr/bin/env bash
set -euo pipefail

mount /dev/mapper/EncryptedUbuntuRoot /mnt
for n in proc sys dev etc/resolv.conf; do mount --rbind /$n /mnt/$n; done
chroot /mnt /bin/bash