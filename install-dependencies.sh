#!/bin/bash -x 

#Install Docker on VM
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl snapd binfmt-support qemu qemu-user-static gnupg-agent nfs-kernel-server nfs-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
    && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io \
    && sudo usermod -aG docker ${USER} \
    && sudo chmod 666 /var/run/docker.sock \
    && sudo systemctl start docker && sudo systemctl enable docker \
    && sudo systemctl enable --now nfs-server
#Install kubectl & yq
sudo snap install kubectl --classic
sudo snap install yq
