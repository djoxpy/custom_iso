#!/bin/bash
TERM=linux

while [ -n "$1" ]
do
case "$1" in

--help) echo -e "\vScript for monitoring CPU% by threads. Can be used for <nsmon@x>, <nsdpi@x> and other <processes>\n\vUsage:\n ./zabbix_proc -[option] <process name>\t| Always use only one parameter\n\vOptions:\n -l\t\tsearch by <process name>\n -w\t\twrite COLLECTION of <process name> to /etc/zabbix/zabbix_agentd.conf\n -s\t\twrite a SINGLE process to /etc/zabbix/zabbix_agentd.conf\n -d\t\tdelete <process name> from /etc/zabbix/zabbix_agentd.conf\n -p\t\tshow CPU% by thread\n -j\t\tformat to JSON by <process name>\n --grand\tcreate UserParameters for Discovery, first parameter is <MASTER ITEM KEY>, second parameter is <ITEM KEY>\n --allow\tallow 'sudo' permission to execute the command 'top' as 'zabbix' user\n --discard\tdiscard 'sudo' permission to execute the command 'top' as 'zabbix' user"
shift ;;

-l) p="$2"
if [ -n "$2" ]
then 
proc=`top -Hbn1 | grep $p | sort -n -k1 | awk '{print "PID: "$1, "| "$NF}'`
IFS=$'\n'
for var in $proc
do
echo -e "\033[32m$var\e[0m"
done
else
echo "No parameters found. Parameter is name of process. Use for example 'mysqld'"
fi
shift ;;

-w) p="$2"
if [ -n "$2" ]
then
proc=`top -Hbn1 | grep $p | awk '{print $NF}'`
for var in $proc
do
echo UserParameter=${var//@/}_util,/etc/zabbix/zabbix_proc.sh -p $var >> /etc/zabbix/zabbix_agentd.conf
done
systemctl restart zabbix-agent
else
echo "No parameters found. Parameter is name of process. Use for example 'mysqld'"
fi
shift ;;

-s) p=($2)
if [ -n "$2" ]
then
proc=(`top -bn1 | grep $p | awk '{print $NF}'`)
if [ $p == $proc ]
then
echo UserParameter=${p//@/}_util,/etc/zabbix/zabbix_proc.sh -p $p >> /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
fi
else
echo "No parameters found. Parameter is name of process. Use for example 'mysqld'"
fi
shift ;;

-p) p="$2"
if [ -n "$2" ]
then
comm=$(sudo top -Hbn1 -w 200 | grep -w $p | awk '{print $9}')
echo $comm
else
echo "No parameters found. Parameter is name of process. Use for example 'mysqld'"
fi
shift ;;

-d) p="$2"
if [ -n "$2" ]
then
sed -i "/UserParameter=$p/d" /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
else
echo "No parameters found. Parameter is name of process. Use for example 'mysqld'"
fi
shift ;;

-j) p="$2"
g=$(top -Hbn1 -w 200 | grep $p | awk '{print $NF}' ORS=',')
#g=$(ps -e -T | grep $p | awk '{print $NF}' ORS=',') #alternative
pid=$(top -Hbn1 -w 200 | grep $p | awk '{print $1}' ORS=',')
IFS="," read -r -a customArray <<< $g
IFS="," read -r -a pidArray <<< $pid
echo -e "["
for ((c=0; c<${#customArray[@]} && c<${#pidArray[@]}; c++)) 
do
if ((c==$((${#customArray[@]}-1))));
then
echo -e "{\"proc\":\"${customArray[c]}\",\t\"pid\":\"${pidArray[c]}\"}"
else
echo -e "{\"proc\":\"${customArray[c]}\",\t\"pid\":\"${pidArray[c]}\"},"
fi
done
echo -e "]"
shift ;;

--allow) echo "zabbix ALL=(ALL) NOPASSWD: /bin/top" > /etc/sudoers.d/zabbix
chown zabbix:zabbix /etc/zabbix/zabbix_proc.sh
echo "UnsafeUserParameters=1" >> /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
echo -e "\n=====\033[33mAllowed sudo permission to execute the command 'top' as 'zabbix' user\e[0m=====\n"
shift ;;

--discard) rm /etc/sudoers.d/zabbix
sed -i "/UnsafeUserParameters=1/d" /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
echo -e "\n=====\033[33mDiscarded sudo permission to execute the command 'top' as 'zabbix' user\e[0m=====\n"
shift ;; 

--grand) p="$2"
d="$3"
echo UserParameter=${p}[*],/etc/zabbix/zabbix_proc.sh -j \$1 >> /etc/zabbix/zabbix_agentd.conf
echo UserParameter=${d}[*],/etc/zabbix/zabbix_proc.sh -p \$1 >> /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
echo -e "\033[32m=====Added Discovery parameters=====\e[0m"
shift ;;

#*) echo "$1 is not an option";;
esac
shift
done
