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
	sudo apt update -y && sudo apt install mysql-server mysql-client
fi

if [ "$os" == "cpe:/o:centos:centos:7" ]; 
then
	sudo yum install -y curl
	curl -sSLO https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm
	sudo rpm -ivh mysql80-community-release-el7-5.noarch.rpm
	sudo yum install -y mysql-server
	sudo systemctl start mysqld && sudo systemctl enable mysqld
	sudo grep 'temporary password' /var/log/mysqld.log
fi

if [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo dnf install -y mysql-server
	sudo systemctl start mysqld && sudo systemctl enable mysqld
fi
