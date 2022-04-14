#!/bin/bash
declare -a arr=("ubuntu" "cpe:/o:centos:centos:7" "cpe:/o:centos:centos:8")

for i in ${arr[@]};
do
if grep -q "$i" cat /etc/*release > /dev/null 2>&1
then 
	os=$i
break
fi
done

if [ "$os" == "ubuntu" ];
then
	sudo apt update -y && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s
    exec bash
fi

if [ "$os" == "cpe:/o:centos:centos:7" ] || [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo yum install -y curl tar
    curl -L get.rvm.io | bash -s
    exec bash
fi