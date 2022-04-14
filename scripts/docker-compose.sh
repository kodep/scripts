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

if [ "$os" == "ubuntu" ] || [ "$os" == "cpe:/o:centos:centos:7" ] || [ "$os" == "cpe:/o:centos:centos:8" ];
then
	sudo curl -L "https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi