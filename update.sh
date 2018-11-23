#!/bin/bash
systemctl stop webgui
systemctl stop ssmgr
npm i -g shadowsocks-manager --unsafe-perm
systemctl start webgui
systemctl start ssmgr
