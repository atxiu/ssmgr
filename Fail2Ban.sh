#!/bin/bash
yum install -y epel-release
yum install -y fail2ban fail2ban-systemd
yum update -y selinux-policy*
(
cat <<EOF
[DEFAULT]
ignoreip = 127.0.0.1/8
bantime  = 86400
findtime = 600
maxretry = 5
banaction = firewallcmd-ipset
action = %(action_mwl)s
[sshd]
enabled = true
port = ssh
#action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 5
bantime = 86400
EOF
)>/etc/fail2ban/jail.local
systemctl enable firewalld
systemctl start firewalld
systemctl enable fail2ban
systemctl start fail2ban 
