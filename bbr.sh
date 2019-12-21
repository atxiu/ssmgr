#!/bin/bash
#开启bbr
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml -y
egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d \'
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
reboot
