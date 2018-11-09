#!/bin/bash
yum install centos-release-yum4 -y
yum install dnf -y
echo "fastestmirror=true" >> /etc/dnf/dnf.conf
dnf install dnf-plugins-core epel-release -y
dnf update -y
LANG=en_US.UTF-8
dnf copr enable librehat/shadowsocks -y
dnf install shadowsocks-libev m2crypto rng-tools -y
(
cat <<EOF
[Unit]
Description=ssmgr
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ssmgr -c /root/.ssmgr/ss.yml -r libev:chacha20-ietf
#User=nobody
#Group=nobody

[Install]
WantedBy=multi-user.target
EOF
)>/usr/lib/systemd/system/ssmgr.service
(
cat <<EOF
[Unit]
Description=Hardware RNG Entropy Gatherer Daemon

[Service]
ExecStart=/sbin/rngd -f -r /dev/urandom

[Install]
WantedBy=multi-user.target
EOF
)>/usr/lib/systemd/system/rngd.service
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
sudo yum install -y nodejs
npm i -g shadowsocks-manager --unsafe-perm
mkdir ~/.ssmgr
(
cat <<EOF
type: s

shadowsocks:
  address: 127.0.0.1:4000
manager:
  address: 0.0.0.0:4001
  password: '123456'
db: 'ss.sqlite'
EOF
)>/root/.ssmgr/ss.yml
systemctl start rngd.service
systemctl enable rngd.service
systemctl start ssmgr.service
systemctl enable ssmgr.service
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
dnf --enablerepo=elrepo-kernel install kernel-ml -y
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
(
cat <<EOF
# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# for high-latency network
net.ipv4.tcp_congestion_control = hybla

# for low-latency network, use cubic instead
# net.ipv4.tcp_congestion_control = cubic
EOF
)>/etc/sysctl.d/local.conf
sysctl --system
reboot
