#!/bin/bash
yum install -y epel-release
yum install -y fail2ban fail2ban-systemd
yum update -y selinux-policy*
cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
(
cat <<EOF
[sshd]
enabled = true
port = ssh
#action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 5
bantime = 86400
EOF
)>/etc/sysctl.d/local.conf
systemctl enable firewalld
systemctl start firewalld
systemctl enable fail2ban
systemctl start fail2ban 
