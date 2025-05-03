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
echo "fs.inotify.max_user_instances = 16384" >> /etc/sysctl.conf
echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf
echo "vm.swappiness = 0" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf

#tuning limits.conf
echo "* soft    nproc    65535" >> /etc/security/limits.conf
echo "* hard    nproc    65535" >> /etc/security/limits.conf
echo "* soft    nofile   65535" >> /etc/security/limits.conf
echo "* hard    nofile   65535" >> /etc/security/limits.conf
echo "* soft    memlock  unlimited" >> /etc/security/limits.conf
echo "* hard    memlock  unlimited" >> /etc/security/limits.conf

echo "root soft    nproc    65535" >> /etc/security/limits.conf  
echo "root hard    nproc    65535" >> /etc/security/limits.conf
echo "root soft    nofile   65535" >> /etc/security/limits.conf
echo "root hard    nofile   65535" >> /etc/security/limits.conf

echo "1001 soft    nproc    65535" >> /etc/security/limits.conf  
echo "1001 hard    nproc    65535" >> /etc/security/limits.conf
echo "1001 soft    nofile   65535" >> /etc/security/limits.conf
echo "1001 hard    nofile   65535" >> /etc/security/limits.conf

#Setup NTP
wget https://raw.githubusercontent.com/praparn/sourcesetup/master/standard_ntp.sh
sudo chmod +x ./standard_ntp.sh
./standard_ntp.sh

#create 1001 user
groupadd docker
useradd -u 1001 --no-create-home 1001
mkdir -p /var/www && sudo chown 1001:1001 /var/www
mkdir -p /var/dockers && sudo chown 1001:1001 /var/dockers

#install docker
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common
### Add Docker’s official GPG key
#mkdir -p /etc/apt/keyrings
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "10"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker


#add ubuntu and 1001 to docker group
sudo usermod -a -G docker ubuntu
sudo usermod -a -G docker 1001
#restart
#reboot