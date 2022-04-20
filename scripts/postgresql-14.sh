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
	sudo apt update -y && sudo apt install -y apt-transport-https ca-certificates wget gnupg-agent software-properties-common
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo apt update -y
	sudo apt install -y postgresql-14
fi

if [ "$os" == "cpe:/o:centos:centos:7" ]; 
then
	sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
	sudo yum install -y postgresql14-server
	sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
	sudo systemctl start postgresql-14 && sudo systemctl enable postgresql-14
fi

if [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
	sudo dnf -qy module disable postgresql
	sudo dnf install -y postgresql14-server
	sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
	sudo systemctl enable postgresql-14 && sudo systemctl start postgresql-14
fi
