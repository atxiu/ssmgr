#!/bin/bash
domain=$1
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c 16)
apt install nginx
(
cat <<EOF >> /etc/nginx/conf.d/$domain.conf
server {
  listen         80;
  server_name    $domain;
  location / {
      root /usr/share/nginx/html;
      index index.html;
  }
}
EOF
)
systemctl restart nginx
curl https://get.acme.sh | sh -s email=my@example.com
source ~/.bashrc
/root/.acme.sh/acme.sh --issue -d $domain --nginx
(
cat <<EOF >> /etc/nginx/conf.d/$domain.conf
server {  
  listen                 1234 ssl http2;
  server_name            $domain;
  ssl                    on;
  ssl_stapling on;
  ssl_stapling_verify    on;
  resolver               1.1.1.1 8.8.8.8 valid=300s;
  resolver_timeout 5s; 
  ssl_protocols          TLSv1.1 TLSv1.2;
  location / {
      root /usr/share/nginx/html;
      index index.html; 
  }
  ssl_certificate /root/.acme.sh/$domain/fullchain.cer;
  ssl_certificate_key /root/.acme.sh/$domain/$domain.key;
}
EOF
)
mkdir cert
/root/.acme.sh/acme.sh --install-cert -d $domain --fullchain-file ./cert/full.cer --key-file ./cert/key.key
systemctl restart nginx
systemctl enable nginx
(
cat <<EOF >> docker-compose.yml
# docker-compose.yml
version: '3'
services:
  ssmgr-redis:
    image: redis:5.0-alpine
    network_mode: host
    volumes:
      - ./redis/data:/data
    entrypoint: redis-server --appendonly yes --requirepass wzXA7AWwcOw2WVIAe+i1/pX7qAcKhDEMLWv4b6zLmpVZDEMOOev7PMvFI46xvtARZKsTTCpR7gTHD4ra
    #command: ["redis-server", "--appendonly", "yes"]
  trojan-go:
    image: atxiu/trojan-go-redis
    restart: always
    network_mode: host
    volumes:
      - ./config.json:/root/config.json
      - ./cert/full.cer:/cert/full.cer
      - ./cert/key.key:/cert/key.key
    depends_on:
      - ssmgr-redis
  ssmgr-trojan-client:
    image: llc1123/ssmgr-trojan-client
    restart: always
    network_mode: host
    command: ["ssmgr-trojan-client", "--db-password", "wzXA7AWwcOw2WVIAe+i1/pX7qAcKhDEMLWv4b6zLmpVZDEMOOev7PMvFI46xvtARZKsTTCpR7gTHD4ra", "-k", "$passwd"]
    depends_on:
      - trojan-go
      - ssmgr-redis
EOF
)
(
cat <<EOF >> config.json
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$passwd"
    ],
    "ssl": {
        "cert": "/cert/full.cer",
        "key": "/cert/key.key",
        "fallback_port": 1234
    },
    "redis": {
        "enabled": true,
        "server": "127.0.0.1",
        "port": "6379",
        "password":"wzXA7AWwcOw2WVIAe+i1/pX7qAcKhDEMLWv4b6zLmpVZDEMOOev7PMvFI46xvtARZKsTTCpR7gTHD4ra"
    }
}
EOF
)
docker-compose up -d
echo "连接端口：4001"
echo "连接密码：$passwd"
