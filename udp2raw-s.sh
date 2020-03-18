#!/bin/bash
pwd=$(pwd)
folder=$1
lport=$2
rport=$[rport-1]
tun=$[rport-8800]
mkdir $pwd/.udp2raw
mkdir $pwd/.udp2raw/$folder
(
cat <<EOF >$pwd/.udp2raw/$folder/docker-compose.yml
# docker-compose.yml
version: '3'
services:
  tinyvpn:
    image: atxiu/tinyfecvpn
    restart: always
    command: "-s \
      -l 127.0.0.1:$rport \
      --mode 0  \
      --mtu 1200 \
      -f 2:0 \
      --timeout 0 \
      --disable-obscure \
      --disable-checksum \
      --tun-dev tun1$tun \
      --sub-net 10.11.$tun.0 \
      --sock-buf 10240 \
      --mssfix 0"
    network_mode: "host"
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
  udp2raw-aes:
    image: atxiu/udp2raw-aes
    restart: always
    command: "-s \
      -k anjoy \
      -l 0.0.0.0:$lport \
      -r 127.0.0.1:$rport \
      -a \
      --raw-mode faketcp \
      --cipher-mode aes128cfb \
      --auth-mode hmac_sha1 \
      --seq-mode 3 \
      --sock-buf 10240 \
      --force-sock-buf \
      --keep-rule \
      --fix-gro"
    network_mode: "host"
    cap_add:
      - NET_ADMIN
EOF
)
/usr/local/bin/docker-compose -f $pwd/.udp2raw/$folder/docker-compose.yml up -d
chmod +x $pwd/.udp2raw/$folder/docker-compose.yml
echo "/usr/local/bin/docker-compose -f $pwd/.udp2raw/$folder/docker-compose.yml up -d"
echo "Add to /etc/rc.local"
cat $pwd/.ssmgr/${folder:-ds}/docker-compose.yml
