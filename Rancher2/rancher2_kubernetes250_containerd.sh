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
#special for rke2
echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.d/90-rke2.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/90-rke2.conf
mkdir /etc/NetworkManager/conf.d
curl https://raw.githubusercontent.com/praparn/sourcesetup/master/Rancher2/rke2-canal.conf > /etc/NetworkManager/conf.d/rke2-canal.conf
#special for rke2

#tuning limits.conf
echo "* soft    nproc    65535" >> /etc/security/limits.conf
echo "* hard    nproc    65535" >> /etc/security/limits.conf
echo "* soft    nofile   65535" >> /etc/security/limits.conf
echo "* hard    nofile   65535" >> /etc/security/limits.conf
echo "root soft    nproc    65535" >> /etc/security/limits.conf  
echo "root hard    nproc    65535" >> /etc/security/limits.conf
echo "root soft    nofile   65535" >> /etc/security/limits.conf
echo "root hard    nofile   65535" >> /etc/security/limits.conf

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

#Disable firewall (base on rancher recommend)
systemctl stop ufw
systemctl disable ufw
systemctl stop firewalld
systemctl disable firewalld
#Disable firewall (base on rancher recommend)

#install containerd
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release

#Install Kubernetes Base
curl -sLo /etc/apt/trusted.gpg.d/kubernetes-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update && apt-get install -y kubectl=1.26.0-00 && apt-mark hold kubectl

#Install Helm Base
cd /tmp
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
#restart
sudo shutdown -r now
#reboot