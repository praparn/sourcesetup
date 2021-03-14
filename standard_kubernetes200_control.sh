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
echo "net.ipv4.ip_local_port_range = 2000 65000" >> /etc/sysctl.conf
echo "fs.file-max = 1000000" >> /etc/sysctl.conf
echo "vm.swappiness = 0" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf

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
mkdir -p /var/www && sudo chown 1001:1001 /var/www

#install cri-o
# Create the .conf file to load the modules at bootup
curl https://raw.githubusercontent.com/praparn/kubernetes_202104/main/WorkShop_1.1_Install_Kubernetes/crio.conf > /etc/modules-load.d/crio.conf
chmod +x /etc/modules-load.d/crio.conf
modprobe overlay
modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
curl https://raw.githubusercontent.com/praparn/kubernetes_202104/main/WorkShop_1.1_Install_Kubernetes/99-kubernetes-cri.conf > /etc/sysctl.d/99-kubernetes-cri.conf
sysctl --system
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.20/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:1.20.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:1.20/xUbuntu_20.04/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers-cri-o.gpg add -

sudo apt-get update
sudo apt-get -y install cri-o cri-o-runc apt-transport-https ca-certificates curl
sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00
sudo apt-mark hold kubelet kubeadm kubectl
#restart
#reboot