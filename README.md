# ssmgr

#### shadowsocks-manager s端自动化部署，默认为AES-256-GCM，密码16位大小写字母随机。
docker
```
bash <(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/ds.sh) s1 6001 aes-128-gcm
```

tiny py版带bbr
```
bash <(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/py-tiny.sh) rc4-md5
```
~~curl -fsSL https://raw.github.com/atxiu/ssmgr/master/py-tiny.sh | bash -s rc4-md5~~
~~sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/py-tiny.sh)"~~

tiny版不带bbr
```
sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/ssmgr-tiny.sh)"
```
tiny版带bbr
```
sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/ssmgr-tiny-bbr.sh)"
```
原版不带bbr
```
sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/ssmgr.sh)"
```
原版带bbr
```
sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/ssmgr-bbr.sh)"
```
删除阿里云盾及监控
```
sh -c "$(curl -fsSL https://raw.github.com/atxiu/ssmgr/master/remove-aliyun.sh)"
```
