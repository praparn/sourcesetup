#!/usr/bin/env bash

#Set LC_ALL, LANG
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locate
echo "LANG=en_US.UTF-8" >> /etc/default/locate

#tuning sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 9" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 7200" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 5" >> /etc/sysctl.conf
echo "net.ipv4.tcp_no_metrics_save = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse=1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout=15" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 2000 65000" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
echo "fs.file-max = 1000000" >> /etc/sysctl.conf
echo "vm.swappiness = 0" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
echo "kernel.unprivileged_userns_clone = 0" >> /etc/sysctl.conf

#tuning limits.conf
echo "* soft    nproc    65535" >> /etc/security/limits.conf
echo "* hard    nproc    65535" >> /etc/security/limits.conf
echo "* soft    nofile   65535" >> /etc/security/limits.conf
echo "* hard    nofile   65535" >> /etc/security/limits.conf
echo "root soft    nproc    65535" >> /etc/security/limits.conf  
echo "root hard    nproc    65535" >> /etc/security/limits.conf
echo "root soft    nofile   65535" >> /etc/security/limits.conf
echo "root hard    nofile   65535" >> /etc/security/limits.conf

#create 1001 user
useradd -u 1001 --no-create-home 1001

#set timezone bangkok
timedatectl set-timezone Asia/Bangkok

#configure prerequisites for enable module ipvs, overlay, netfilter
echo "" > /etc/modules
echo "ip_vs" >> /etc/modules
echo "ip_vs_rr" >> /etc/modules
echo "ip_vs_wrr" >> /etc/modules
echo "ip_vs_sh" >> /etc/modules
echo "nf_conntrack_ipv4" >> /etc/modules
echo "overlay" >> /etc/modules
echo "br_netfilter" >> /etc/modules

#install containerd
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install -y net-tools apt-transport-https ca-certificates curl gnupg software-properties-common ipvsadm lsb-release
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y net-tools apt-transport-https ca-certificates curl gnupg software-properties-common ipvsadm lsb-release containerd.io
rm /etc/containerd/config.toml


#Install Kubernetes Base
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl=1.26.0-00 kubelet=1.26.0-00 kubeadm=1.26.0-00 && apt-mark hold kubelet kubeadm kubectl

#Install kubectl convert plugin
cd ~
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert.sha256"
echo "$(cat kubectl-convert.sha256) kubectl-convert" | sha256sum --check
install -o root -g root -m 0755 kubectl-convert /usr/local/bin/kubectl-convert
#kubectl convert --help
rm kubectl-convert kubectl-convert.sha256

#restart
sudo shutdown -r now
#reboot