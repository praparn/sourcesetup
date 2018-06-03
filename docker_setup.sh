#Install Base docker-engine
sudo apt-get update
sudo apt-get remove docker docker-engine
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y install docker-ce 
sudo apt-get -y install nfs-kernel-server
sudo apt-get -y install nfs-common
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker