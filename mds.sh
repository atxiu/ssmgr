#!/bin/bash
folder=$1
sport=$2
method=$3
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c 16)
yum install epel-release -y
yum install docker docker-compose -y
systemctl start docker
systemctl enable docker
docker pull gyteng/ssmgr-tiny
mkdir /root/.ssmgr
mkdir /root/.ssmgr/${folder:-ds}
(
cat <<EOF
# docker-compose.yml
version: '3'

services:
 ${folder:-ds}:
  image: gyteng/ssmgr-tiny
  restart: always
  network_mode: host
  command: node /ssmgr/index.js -s 127.0.0.1:${sport:-6601} -m 0.0.0.0:$[${sport:-6601}+1] -p $passwd -r libev:${method:-aes-128-gcm} -d ./data.json
EOF
)>/root/.ssmgr/${folder:-ds}/docker-compose.yml
/usr/bin/docker-compose -f /root/.ssmgr/${folder:-ds}/docker-compose.yml up -d
chmod -Rf 755 /root/.ssmgr/
echo "/usr/bin/docker-compose -f /root/.ssmgr/${folder:-ds}/docker-compose.yml up -d" >>/etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
cat /root/.ssmgr/${folder:-ds}/docker-compose.yml
