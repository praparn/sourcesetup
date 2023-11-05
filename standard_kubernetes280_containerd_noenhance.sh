#!/usr/bin/env bash

#install containerd
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS

apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release
curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-keyring.gpg
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable"
#mkdir -m 0755 -p /etc/apt/keyrings (for ubuntu 20.04)
apt update && apt -y install containerd.io net-tools
containerd config default                              \
 | sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
 | sudo tee /etc/containerd/config.toml
systemctl restart containerd

#Install Kubernetes Base
curl -sLo /etc/apt/trusted.gpg.d/kubernetes-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update && apt-get install -y kubectl=1.28.0-00 kubelet=1.28.0-00 kubeadm=1.28.0-00 && apt-mark hold kubelet kubeadm kubectl
#restart
sudo shutdown -r now
#reboot