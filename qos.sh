#!/bin/bash
tc qdisc add dev eth0 root handle 1: htb default 1
tc class add dev eth0 parent 1: classid 1:1 htb rate 1000Mbit
tc class add dev eth0 parent 1:1 classid 1:10 htb rate 800kbit ceil 800kbit
tc filter add dev eth1 parent 1: protocol ip prio 2 u32 match ip dst 10.1.10.59/24 flowid 1:1

tc qdisc add dev eth0 root handle 1: htb default 20
tc class add dev eth0 parent 1:0 classid 1:1 htb rate 500Mbit
tc class add dev eth0 parent 1:1 classid 1:20 htb rate 0.5Mbit ceil 2Mbit
tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10
tc filter add dev eth0 parent 1:20 protocol ip u32 match ip sport 63210 0xffff classid 1:20
