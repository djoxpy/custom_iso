#!/bin/sh

if [ -z "$2" ]; then
    echo "Usage: $0 srv_id srv_name"
    exit 1
fi

if [ `id -u` != 1001 ]; then
    echo This script must be running under netscan user
    exit 1
fi

cd $HOME
mv .bash_profile .bash_profile-OLD
mkdir -p /opt/netscan/tmp /opt/netscan/lib /opt/netscan/etc 
cat <<EOF > .profile
export PS1='$2:\\w\$ '
PATH=/opt/netscan/bin:\$PATH
export NETSCAN_SRV=$1
export NETSCAN_CFG=/opt/netscan/etc/netscan.cfg
export LD_LIBRARY_PATH=/opt/netscan/lib
export PERL5LIB=/opt/netscan/lib/perl5
export TMPDIR=/opt/netscan/tmp
export LESS=-n
ulimit -c unlimited
EOF
