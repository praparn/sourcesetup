#!/usr/bin/env bash
# In case of proxy we need to add proxy configuation on file like below:
# 1. Add apt configuration for proxy by command: sudo vi /etc/apt/apt.conf
# Acquire::http::Proxy "http://username:password@<proxy ip>:<port>/";
# Acquire::https::Proxy "http://username:password@<proxy ip>:<port>";

# 2. export proxy configuration like below:
#   - sudo vi ~/.bashrc
#   - Add this on bottom line
#       export {http,https,ftp}_proxy="http://username:password@<proxy ip>:<port>/"
#       export no_proxy="localhost,127.0.0.1,10.0.0.0/8,172.16.0.0/16, 192.168.0.0/16"

#  3. Check UMARK on system with value below:
#    - sudo vi /etc/login.defs  ==> UMASK           022

#  4. Add /etc/default/located by command:
#    - sudo su -
#    - vi /etc/default/locate ==> 
#           LC_ALL=en_US.UTF-8
#           LANG=en_US.UTF-8

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

#create 1001 user
useradd -u 1001 --no-create-home 1001
mkdir -p /var/www && sudo chown 1001:1001 /var/www
mkdir -p /var/dockers && sudo chown 1001:1001 /var/dockers

#install docker
apt-get update && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

#install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#add ubuntu and 1001 to docker group
usermod -a -G docker ubuntu
usermod -a -G docker 1001

#add ubuntu and 1001 to docker group
usermod -a -G docker ubuntu
usermod -a -G docker 1001

#After Finished in case of proxy you need to configure proxy for docker to pull image like detail below
#Create file http-proxy.conf and configure proxy privilege by command: (docker_proxy.sh)
#   -sudo vi /etc/systemd/system/docker.service.d/http-proxy.conf
	
#	[Service]
#	Environment="HTTP_PROXY=http://username:password@<proxy>:<port>/"
#	Environment="NO_PROXY=localhost,127.0.0.1,10.0.0.0/8,172.0.0.0/8,192.168.0.0/16"
#restart
#reboot