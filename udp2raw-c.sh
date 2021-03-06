#!/bin/bash
pwd=$(pwd)
folder=$1
rip=$2
rport=$3
lport=$[rport-1]
tun=$[rport-8800]
mkdir $pwd/.udp2raw
mkdir $pwd/.udp2raw/$folder
(
cat <<EOF >$pwd/.udp2raw/$folder/docker-compose.yml
# docker-compose.yml
version: '3'
services:
  udp2raw-aes:
    image: atxiu/udp2raw-aes
    restart: always
    command: "-c \
      -k anjoy \
      -l 127.0.0.1:$lport \
      -r $rip:$rport \
      -a \
      --raw-mode faketcp \
      --cipher-mode aes128cfb \
      --auth-mode hmac_sha1 \
      --seq-mode 3 \
      --sock-buf 10240 \
      --force-sock-buf \
      --lower-level auto \
      --fix-gro"
    network_mode: "host"
    cap_add:
      - NET_ADMIN
  tinyvpn:
    image: atxiu/tinyfecvpn
    restart: always
    command: "-c \
      -r 127.0.0.1:$lport \
      --mode 0  \
      --mtu 1200 \
      -f 2:0 \
      --timeout 0 \
      --disable-obscure \
      --disable-checksum \
      --tun-dev tun1$tun \
      --sub-net 10.11.$tun.0 \
      --sock-buf 10240 \
      --keep-reconnect \
      --mssfix 0"
    network_mode: "host"
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
EOF
)
/usr/local/bin/docker-compose -f $pwd/.udp2raw/$folder/docker-compose.yml up -d
chmod +x $pwd/.udp2raw/$folder/docker-compose.yml
echo "/usr/local/bin/docker-compose -f $pwd/.udp2raw/$folder/docker-compose.yml up -d"
echo "Add to /etc/rc.local"
cat $pwd/.udp2raw/${folder:-ds}/docker-compose.yml
