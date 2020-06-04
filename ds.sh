#!/bin/bash
folder=$1
sport=$2
method=$3
pwd=$(pwd)
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c 16)
docker pull gyteng/ssmgr-tiny
mkdir $pwd/.ssmgr
mkdir $pwd/.ssmgr/${folder:-ds}
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
    deploy:
      resources:
        limits:
          cpus: '0.25'
          memory: 200M
        reservations:
          cpus: '0.1'
          memory: 50M
EOF
)>$pwd/.ssmgr/${folder:-ds}/docker-compose.yml
/usr/local/bin/docker-compose -f $pwd/.ssmgr/${folder:-ds}/docker-compose.yml up -d
chmod +x $pwd/.ssmgr/${folder:-ds}/docker-compose.yml
echo "/usr/local/bin/docker-compose -f $pwd/.ssmgr/${folder:-ds}/docker-compose.yml up -d"
echo "Add to /etc/rc.local"
cat $pwd/.ssmgr/${folder:-ds}/docker-compose.yml
