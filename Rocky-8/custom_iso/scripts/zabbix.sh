#!/bin/sh

FILE=/etc/zabbix_agentd.conf

if [ -z "$1" ]
then
    echo Usage: $0 172.16.48.59/26
    exit 1
fi

SRV="$1"
IP=$(echo "$SRV" | cut -d/ -f1)

systemctl stop zabbix-agent

sed -i "/^Server=/c Server=$SRV" $FILE
sed -i '/StartAgents=/c StartAgents=1' $FILE
sed -i "/^ServerActive=/c ServerActive=$IP" $FILE
sed -i '/^Hostname=/s//# &/' $FILE
sed -i '/HostnameItem=/c HostnameItem=system.hostname' $FILE
sed -i '/Include=$/ cInclude=/etc/zabbix/zabbix_agentd.d/*.conf' $FILE
sed -i '/UnsafeUserParameters=0/c UnsafeUserParameters=1' $FILE

curl -s http://172.16.48.59/nqp/ns_zabbix.tgz | tar xz -C/etc

echo "zabbix ALL=(ALL) NOPASSWD: /bin/top" > /etc/sudoers.d/zabbix
chown zabbix:zabbix /etc/zabbix/zabbix_proc.sh

rm -f /etc/zabbix/zabbix_agentd.conf.rpmnew

systemctl enable --now zabbix-agent



# UnsafeUserParameters=1
