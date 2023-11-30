#!/bin/sh

LABEL="Rocky-8-7-x86_64-dvd"

DATE=$(date +%d_%m_%Y)

SOURCE="$1"
OUTPUT="$2"
PREFIX="$3"
NAME=$OUTPUT/$PREFIX-Rocky-8.7-x86_64-minimal-$DATE.iso

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $0 [SOURCE] [DESTINATION] [PREFIX]"
    exit 1
fi

mkisofs -o $NAME -R -J -V $LABEL -joliet-long -b isolinux/isolinux.bin -c isolinux/boot.cat -boot-load-size 4 -boot-info-table -no-emul-boot -eltorito-alt-boot -e images/efiboot.img -no-emul-boot $SOURCE

isohybrid --uefi $NAME

implantisomd5 $NAME