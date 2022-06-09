#!/bin/bash

declare -a arr=("cpe:/o:centos:centos:7" "ubuntu" "cpe:/o:centos:centos:8")

for i in ${arr[@]};
do
if grep -q "$i" /etc/*release > /dev/null 2>&1
then 
	os=$i
break
fi
done
if [ "$os" == "ubuntu" ]; 
then
	sudo apt update && sudo apt install -y software-properties-common ca-certificates
	sudo sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-apt-config
	deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-5.7
	deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-tools
	#deb http://repo.mysql.com/apt/ubuntu/ bionic mysql-tools-preview
	deb-src http://repo.mysql.com/apt/ubuntu/ bionic mysql-5.7" > /etc/apt/sources.list.d/mysql.list'
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
	sudo apt update
	sudo apt install -y -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
fi

if [ "$os" == "cpe:/o:centos:centos:7" ]; 
then
	sudo yum install -y curl
	curl -sSLO https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
	sudo rpm -ivh mysql57-community-release-el7-11.noarch.rpm
	sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
	sudo yum install -y mysql-server
	sudo systemctl start mysqld && sudo systemctl enable mysqld
	sudo grep 'temporary password' /var/log/mysqld.log
fi

if [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo touch /etc/yum.repos.d/mysql-community.repo
	sudo sh -c 'echo "[mysql-connectors-community]
	name=MySQL Connectors Community
	baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/7/\$basearch/
	enabled=1
	gpgcheck=0

	[mysql-tools-community]
	name=MySQL Tools Community
	baseurl=http://repo.mysql.com/yum/mysql-tools-community/el/7/\$basearch/
	enabled=1
	gpgcheck=0

	[mysql57-community]
	name=MySQL 5.7 Community Server
	baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/\$basearch/
	enabled=1
	gpgcheck=0" > /etc/yum.repos.d/mysql-community.repo'
	sudo dnf module disable -y mysql
	sudo dnf config-manager --enable mysql57-community
	sudo yum install -y mysql-server
	sudo systemctl start mysqld && sudo systemctl enable mysqld
	sudo grep 'temporary password' /var/log/mysqld.log
fi
