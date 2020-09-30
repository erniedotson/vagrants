#!/bin/bash
# extend root filesystem on Centos or Ubuntu

echo "> Installing required tools for file system management"
if  [ -n "$(command -v yum)" ]; then
	echo ">> Detected yum-based Linux"
	sudo yum makecache
	sudo yum install -y util-linux
	sudo yum install -y lvm2
	sudo yum install -y e2fsprogs
fi
if [ -n "$(command -v apt-get)" ]; then
	echo ">> Detected apt-based Linux"
	sudo apt-get update -y
	sudo apt-get install -y fdisk
	sudo apt-get install -y lvm2
	sudo apt-get install -y e2fsprogs
fi

sudo fdisk /dev/sda <<EOF
d
n
p



w
EOF

sudo partprobe -s
sudo xfs_growfs /dev/sda1
