#!/bin/bash

mdadm --create --verbose /dev/md0 -l 5 -n 6 /dev/sd{b,c,d,e,f,g}

parted -s /dev/md0 mklabel gpt

for i in $(seq 1 5)
    do
        parted /dev/md0 mkpart primary ext4 (($i - 1) * 20))

blkid | awk '/dev\/md0/ {print$2, "/mnt/raid10", $3, "defaults", 0, 0}' | sed -r 's/\"|TYPE=//'g >> /etc/fstab
mount -a