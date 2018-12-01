#!/bin/bash
curl -sSL http://update.aegis.aliyun.com/download/quartz_uninstall.sh | sudo bash
sudo systemctl daemon-reload
sudo systemctl stop agentwatch.service
sudo systemctl disable agentwatch.service
sudo systemctl stop cloud-config.service
sudo systemctl disable cloud-config.service
sudo systemctl stop cloud-final.service
sudo systemctl disable cloud-final.service
sudo systemctl stop cloud-init-local.service
sudo systemctl disable cloud-init-local.service
sudo systemctl stop cloud-init-upgrade.service
sudo systemctl disable cloud-init-upgrade.service
sudo systemctl stop cloud-init.service
sudo systemctl disable cloud-init.service
sudo systemctl stop cloudmonitor.service
sudo systemctl disable cloudmonitor.service
sudo systemctl stop aegis.service
sudo systemctl disable aegis.service
sudo pip uninstall cloud-init -y
sudo rm -rf /usr/sbin/aliyun_installer
sudo rm -rf /usr/sbin/aliyun-service.backup
sudo rm -rf /var/tmp/aliyun_assist_update.lock
sudo rm -rf /usr/local/cloudmonitor
sudo rm -rf /tmp/aliyun_assist*
sudo rm -rf /usr/local/share/aliyun-assist
sudo rm -rf /etc/rc.d/init.d/agentwatch
sudo rm -rf /etc/rc.d/init.d/cloudmonitor
sudo rm -rf /etc/cloud
sudo rm -rf /var/lib/cloud
sudo rm -rf /var/log/cloud-init.log
sudo rm -rf /run/cloud-init
sudo rm -rf /usr/lib/cloud-init
sudo rm -rf /usr/share/doc/cloud-init
sudo rm -rf /usr/bin/cloud-init-upgrade
sudo rm -rf /run/systemd/generator.late/agentwatch.service
sudo rm -rf /run/systemd/generator.late/cloudmonitor.service
sudo rm -rf /usr/lib/systemd/system/cloud-config.service
sudo rm -rf /usr/lib/systemd/system/cloud-final.service
sudo rm -rf /usr/lib/systemd/system/cloud-init-local.service
sudo rm -rf /usr/lib/systemd/system/cloud-init-upgrade.service
sudo rm -rf /usr/lib/systemd/system/cloud-init.service
sudo rm -rf /usr/lib/systemd/system/cloud-config.target
sudo rm -rf /usr/local/aegis
sudo rm /usr/sbin/aliyun-service
