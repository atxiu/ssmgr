#!/bin/bash
lport=$1
mkdir .status
wget -P .status https://raw.githubusercontent.com/atxiu/ServerStatus/master/clients/client.py
sed -i 's/status.botox.bz/status.ligu.tv/' /root/.status/client.py
sed -i 's/s01/${lport:-HK1}/' /root/.status/client.py
sed -i 's/35601/7891/' /root/.status/client.py
sed -i 's/some-hard-to-guess-copy-paste-password/anjoy/' /root/.status/client.py
