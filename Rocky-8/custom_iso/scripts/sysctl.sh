#!/bin/sh

FILE=/etc/sysctl.d/user-main.conf
rm -f  $FILE
echo fs.suid_dumpable = 1 >> $FILE
echo vm.nr_hugepages = 1024 >> $FILE
echo vm.swappiness = 0 >> $FILE
echo kernel.randomize_va_space = 0 >> $FILE

sysctl fs.suid_dumpable=1
sysctl vm.nr_hugepages=1024
sysctl vm.swappiness=0
sysctl kernel.randomize_va_space=0
