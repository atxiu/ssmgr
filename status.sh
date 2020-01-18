#!/bin/bash
lport=$1
mkdir .status
curl -o .status/client.py https://raw.githubusercontent.com/atxiu/ServerStatus/master/clients/client.py
sed -i 's/status.botox.bz/status.ligu.tv/' /root/.status/client.py
sed -i 's/s01/'${lport:-HK1}'/' /root/.status/client.py
sed -i 's/35601/7891/' /root/.status/client.py
sed -i 's/some-hard-to-guess-copy-paste-password/anjoy/' /root/.status/client.py
chmod 755 .status/client.py
(
cat <<EOF
[Unit]
Description=ServerStatus Client
After=network.target

[Service]
IgnoreSIGPIPE=no
ExecStart=/root/.status/client.py

[Install]
WantedBy=multi-user.target
EOF
)>/lib/systemd/system/status.service
systemctl restart status.service
systemctl enable status.service
systemctl status status.service
