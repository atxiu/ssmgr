#!/bin/bash
#passwd=${1:-123456}
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c ${1:-16})
timedatectl set-timezone Asia/Shanghai
#更新必要服务
yum install centos-release-yum4 -y
#yum 出错 安装dnf兼容一些写法
yum install dnf -y
#启用自动选择最快节点
echo "fastestmirror=true" >> /etc/dnf/dnf.conf
dnf install dnf-plugins-core epel-release wget net-tools -y
#更改为en_US.UTF-8 以提高兼容性
LANG=en_US.UTF-8
#安装
dnf install 'dnf-command(copr)' -y
dnf copr enable librehat/shadowsocks -y
dnf install shadowsocks-libev m2crypto rng-tools -y
#随机数
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
#nodejs8
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
sudo dnf install -y nodejs
npm i -g shadowsocks-manager@0.29.15 --unsafe-perm
mkdir ~/.ssmgr
#config文件，自己改密码
(
cat <<EOF
type: s
shadowsocks:
  address: 127.0.0.1:4000
manager:
  address: 0.0.0.0:4001
  password: '$passwd'
db: 'ss.sqlite'
EOF
)>/root/.ssmgr/ss.yml
#启动随机数和ssmgr
systemctl daemon-reload
systemctl start rngd.service
systemctl enable rngd.service
npm i -g pm2
pm2 --name "s" -f start ssmgr -x -- -c ss.yml -r libev:chacha20-ietf
pm2 startup
pm2 save
#开启bbr
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
dnf --enablerepo=elrepo-kernel install kernel-ml -y
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
#服务器优化
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
#echo '0 1 * * 6 /usr/bin/sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/update.sh)"' > /var/spool/cron/root
#重启
reboot
