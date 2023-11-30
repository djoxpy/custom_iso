#!/bin/sh

chkconfig network on

# Configure NTP client (example for Play)
systemctl daemon-reload
timedatectl set-ntp true

# Configure/start Zabbix!
./zabbix.sh 172.111.11.11/26

# Sentinel LDK
wget -qO- http://172.99.9.9/repo/ns_hasplib.tgz | tar xz -C/
dnf install -y http://172.99.9.9/repo/aksusbd-7.102-1.x86_64.rpm

passwd main-user