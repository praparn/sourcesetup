#Install Base Binary File and Initial Configuration on UltraVNC
sudo apt update && apt install -y \
  xfce4 \
  xfce4-goodies \
  tightvncserver \
  ettercap-common \
  wireshark-gtk \
  nast \
  software-properties-common \
  apt-transport-https \
  wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update && udo apt install code -y