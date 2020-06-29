#Install Base Binary File and Initial Configuration on UltraVNC
sudo apt update && apt install -y \
  ubuntu-desktop \
  vnc4server \
  gnome-panel \
  gnome-settings-daemon \
  metacity \
  nautilus \
  gnome-terminal \
  ettercap-common \
  wireshark \
  nast \
  software-properties-common \
  apt-transport-https \
  wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update && udo apt install code -y
