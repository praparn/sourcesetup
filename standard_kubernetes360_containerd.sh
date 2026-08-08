#!/usr/bin/env bash

#Set LC_ALL, LANG
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locate
echo "LANG=en_US.UTF-8" >> /etc/default/locate

#tuning sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_keepalive_probes = 9" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_keepalive_time = 7200" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_syn_retries = 5" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_no_metrics_save = 1" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.tcp_fin_timeout = 15" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.ipv4.ip_local_port_range = 2000 65000" >> /etc/sysctl.d/10-network-tuning.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/10-network-tuning.conf
echo "fs.file-max = 1000000" >> /etc/sysctl.d/20-openfiles-tuning.conf
echo "vm.swappiness = 0" >> /etc/sysctl.d/30-memory-tuning.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.d/30-memory-tuning.conf
echo "kernel.unprivileged_userns_clone = 0" >> /etc/sysctl.d/05-kernel-tuning.conf

#tuning limits.conf
echo "* soft    nproc    65535" >> /etc/security/limits.d/20-default-limits.conf
echo "* hard    nproc    65535" >> /etc/security/limits.d/20-default-limits.conf
echo "* hard    nproc    65535" >> /etc/security/limits.d/20-default-limits.conf
echo "* soft    nofile   65535" >> /etc/security/limits.d/20-default-limits.conf
echo "* hard    nofile   65535" >> /etc/security/limits.d/20-default-limits.conf
echo "root soft    nproc    65535" >> /etc/security/limits.d/10-root-limits.conf  
echo "root hard    nproc    65535" >> /etc/security/limits.d/10-root-limits.conf
echo "root soft    nofile   65535" >> /etc/security/limits.d/10-root-limits.conf
echo "root hard    nofile   65535" >> /etc/security/limits.d/10-root-limits.conf

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

apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
apt update && apt install -y containerd.io net-tools

mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd


#Install Kubernetes Base
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

apt-get update && apt-get install -y kubectl kubelet kubeadm && apt-mark hold kubelet kubeadm kubectl
#restart
sudo shutdown -r now
#reboot