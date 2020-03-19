#!/bin/bash
pwd=$(pwd)
mkdir $pwd/smartping
cd $pwd/smartping
wget https://github.com/smartping/smartping/releases/download/v0.8.0/smartping-v0.8.0.tar.gz
tar zxvf smartping-v0.8.0.tar.gz -C $pwd/smartping
cd $pwd/smartping
./control start
firewall-cmd --zone=public --add-port=8899/tcp --permanent
firewall-cmd --reload
chmod +x $pwd/smartping/control
echo "$pwd/smartping/control start"
echo "add to /etc/rc.local"
