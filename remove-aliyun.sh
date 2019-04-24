#!/bin/bash
curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
curl -sSL http://update.aegis.aliyun.com/download/uninstall.sh | sudo bash
sudo pkill aliyun-service
sudo rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
sudo rm -rf /usr/local/aegis*
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
sudo /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh stop
sudo /usr/local/cloudmonitor/wrapper/bin/cloudmonitor.sh remove
sudo rm -rf /usr/local/cloudmonitor
