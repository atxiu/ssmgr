#!/bin/bash
systemctl stop ssmgr
systemctl stop webgui
systemctl stop ssvip
npm i -g shadowsocks-manager --unsafe-perm
systemctl start ssmgr
systemctl start webgui
systemctl start ssvip
