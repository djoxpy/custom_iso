#!/bin/sh

# Configure SSH
sed -i '/^#UseDNS /c UseDNS no' /etc/ssh/sshd_config
systemctl reload sshd

# Disable zeroconf route
grep -q NOZEROCONF /etc/sysconfig/network || \
     echo "NOZEROCONF=yes" >> /etc/sysconfig/network

if ! grep -q /usr/local/lib64 /etc/ld.so.conf.d/usrlocal.conf
then
    echo /usr/local/lib >> /etc/ld.so.conf.d/usrlocal.conf
    echo /usr/local/lib64 >> /etc/ld.so.conf.d/usrlocal.conf
    ldconfig
fi
