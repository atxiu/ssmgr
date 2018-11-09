#!/bin/bash
prot=$1
yum -y install gcc gcc-c++ autoconf automake make pcre-devel zlib-devel wget git
nginx=`nginx -v`
if [-n $nginx];then
echo 'nginx installed'
else
wget 'https://nginx.org/download/nginx-1.14.0.tar.gz'
tar -xzvf nginx-1.14.0.tar.gz
git clone https://github.com/zhouchangxun/ngx_healthcheck_module.git
cd nginx-1.14.0 && git apply ../ngx_healthcheck_module/nginx_healthcheck_for_nginx_1.14+.patch
cd nginx-1.14.0 && ./configure --with-stream --add-module=../ngx_healthcheck_module/
cd nginx-1.14.0 && make && make install
ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx
(
cat <<EOF
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
)>/usr/lib/systemd/system/nginx.service
fi
