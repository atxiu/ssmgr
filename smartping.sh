#!/bin/bash
yum install wget -y
mkdir /root/smartping
cd /root/smartping
wget https://github.com/smartping/smartping/releases/download/v0.8.0/smartping-v0.8.0.tar.gz
tar zxvf smartping-v0.8.0.tar.gz -C /root/smartping
cd /root/smartping
./control start
firewall-cmd --zone=public --add-port=8899/tcp --permanent
firewall-cmd --reload
chmod -R 755 /root/smartping/ 
echo "/root/smartping/control start" >>/etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
