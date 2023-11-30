#!/bin/sh

cp /opt/user-main/support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
service mysqld start
ln -s /opt/user-main/bin/mysql /usr/local/bin/mysql