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
	sudo apt update -y && sudo apt install -y apt-transport-https ca-certificates git curl gnupg-agent software-properties-common libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi

if [ "$os" == "cpe:/o:centos:centos:7" ] || [ "$os" == "cpe:/o:centos:centos:8" ]; 
then
	sudo yum install -y git-core curl
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi