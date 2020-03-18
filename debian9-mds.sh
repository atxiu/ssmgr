#!/bin/bash
folder=$1
sport=$2
method=$3
pwd=$(pwd)
passwd=$(< /dev/urandom tr -dc 0-9-A-Z-a-z-|head -c 16)
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker pull gyteng/ssmgr-tiny
mkdir $pwd/.ssmgr
mkdir $pwd/.ssmgr/${folder:-ds}
(
cat <<EOF
# docker-compose.yml
version: '3'
services:
 ${folder:-ds}:
  image: gyteng/ssmgr-tiny
  restart: always
  network_mode: host
  command: node /ssmgr/index.js -s 127.0.0.1:${sport:-6601} -m 0.0.0.0:$[${sport:-6601}+1] -p $passwd -r libev:${method:-aes-128-gcm} -d ./data.json
EOF
)>$pwd/.ssmgr/${folder:-ds}/docker-compose.yml
/usr/local/bin/docker-compose -f $pwd/.ssmgr/${folder:-ds}/docker-compose.yml up -d
chmod +x $pwd/.ssmgr/${folder:-ds}/docker-compose.yml
(
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
)>/etc/rc.local
chmod +x /etc/rc.local
systemctl start rc-local.service
systemctl enable rc-local.service
echo "/usr/local/bin/docker-compose -f $pwd/.ssmgr/${folder:-ds}/docker-compose.yml up -d"
echo "Add to /etc/rc.local"
cat $pwd/.ssmgr/${folder:-ds}/docker-compose.yml
