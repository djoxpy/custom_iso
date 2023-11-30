#!/bin/sh

LREPO=/etc/yum.repos.d/rocky8-local.repo

R=`dnf repolist --enabled | tail -n +2 | grep -v ^local- | cut -f1 -d' '`
if [ -n "$R" ]
then
    echo These repos will be disabled: $R
    dnf config-manager --disable $R
fi

# test -e $LREPO ||
cat <<EOF > $LREPO
[local-appstream]
name=Local Rocky8 Appstream
baseurl=http://172.111.11.11/repos/rocky-linux-8/appstream/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[local-baseos]
name=Local Rocky8 BaseOS
baseurl=http://172.111.11.11/repos/rocky-linux-8/baseos/
gpgcheck=0
enabled=1

[local-epel]
name=Local Rocky8 EPEL
baseurl=http://172.111.11.11/repos/rocky-linux-8/epel/
gpgcheck=0
enabled=1

[local-extras]
name=Local Rocky8 Extras
baseurl=http://172.111.11.11/repos/rocky-linux-8/extras/
gpgcheck=0
enabled=1

[local-powertools]
name=Local Rocky8 PowerTools
baseurl=http://172.111.11.11/repos/rocky-linux-8/powertools/
gpgcheck=0
enabled=1

[local-gluster11]
name=Local Rocky8 Gluster 11
baseurl=http://172.111.11.11/repos/rocky-linux-8/gluster-11/
gpgcheck=0
enabled=1

[local-gluster10]
name=Local Rocky8 Gluster 10
baseurl=http://172.111.11.11/repos/rocky-linux-8/gluster-10/
gpgcheck=0
enabled=0

[local-gluster9]
name=Local Rocky8 Gluster 9
baseurl=http://172.111.11.11/repos/rocky-linux-8/gluster-9/
gpgcheck=0
enabled=0
EOF

echo Currently enabled repositories:
dnf repolist --enabled
