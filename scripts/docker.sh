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
	sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent 	
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
	sudo usermod -aG docker ${USER}
	sudo chmod 666 /var/run/docker.sock
	sudo systemctl start docker && sudo systemctl enable docker
fi

if [ "$os" == "cpe:/o:centos:centos:7" ] || [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo yum install -y curl
	curl -fsSL https://get.docker.com/ | sh
	sudo usermod -aG docker $(whoami)
	sudo systemctl start docker && sudo systemctl enable docker
	sudo chmod 666 /var/run/docker.sock
fi