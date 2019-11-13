#!/bin/bash
MNT="/mnt/raid"
DEV="/dev/md0"

mdadm --create --verbose $DEV -l 5 -n 6 /dev/sd[bcdefg]

parted -s $DEV mklabel gpt
for i in $(seq 1 5)
    do
        parted $DEV mkpart primary ext4 $((($i-1)*20))% $((i*20))%
        mkfs.ext4 $DEV'p'$i
        mkdir -p $MNT'/part'$i
        AWK_CONDITION="/^\/dev\/md0p$i/{print\$5,\"$MNT/part$i\",\$3,\"defaults\",0,0}"
        blkid | awk $AWK_CONDITION | sed -r 's/\"|TYPE=//'g >> /etc/fstab
    done
mount -a
