#!/bin/bash
systemctl status crond.service
systemctl disable crond.service
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c "${1:-16}")
#搬瓦工自家epel源删除了mbedtls、libsodium加密库
sudo yum remove epel-release package-requests python-urllib3 -y
sudo yum install -y yum-fastestmirror yum-plugin-copr curl 
sudo yum copr enable librehat/shadowsocks -y
sudo yum install -y epel-release
sudo yum install shadowsocks-libev haveged git ntpdate -y
timedatectl set-timezone Asia/Shanghai
ntpdate ntp1.aliyun.com
timedatectl set-local-rtc 1
mkdir ~/.ssmgr-tiny
git clone "https://github.com/gyteng/shadowsocks-manager-tiny.git" ~/.ssmgr-tiny
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
sudo yum install -y nodejs
systemctl start haveged.service
systemctl enable haveged.service
npm i -g pm2
pm2 --name "s" -f start node -x -- ~/.ssmgr-tiny/index.js -s 127.0.0.1:6601 -m 0.0.0.0:6602 -p "$passwd" -r libev:aes-128-gcm -d ~/.ssmgr-tiny/data.json
pm2 startup
pm2 save
#服务器优化
(
cat <<EOF
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.netdev_max_backlog = 4096
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla
EOF
)>/etc/sysctl.d/local.conf
sysctl --system
echo '0 1 * * * /usr/bin/pm2 restart all' > /var/spool/cron/root
reboot
