#!/bin/sh

cd /opt/netscan || exit 1
mkdir etc bin
for i in data log outdir tmp export; do
    if [ -d /mnt/netscan ]; then
        mkdir /mnt/netscan/$i
        ln -s /mnt/netscan/$i
    else
        mkdir $i
    fi
done
# mkdir log/oracle 
for i in cors data dchs errs mrep iub tce mgcp tcap sgs dia gtp sip; do
    mkdir outdir/$i;
done

