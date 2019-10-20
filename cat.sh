#!/bin/bash
app="pm2 --name "s" -f start node -x -- ~/.py-tiny/index.js -s 127.0.0.1:6601 -m 0.0.0.0:6602 -p "$passwd" -r python:${1:-aes-128-gcm} -d ~/.py-tiny/s.json"
echo $app
