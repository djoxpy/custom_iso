#!/bin/sh

echo -n "Current SELinux status: "
getenforce
grep '^SELINUX=' /etc/selinux/config
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
echo "After config modification:"
grep '^SELINUX=' /etc/selinux/config
echo "Reboot the machine to apply changes!"
