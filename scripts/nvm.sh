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
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    exec bash
fi

if [ "$os" == "cpe:/o:centos:centos:7" ] || [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo yum install -y curl
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    exec bash
fi