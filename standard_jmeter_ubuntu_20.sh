#Install Base Binary File and Initial Configuration on UltraVNC
sudo apt update && apt install -y \
  tigervnc-standalone-server \
  ubuntu-gnome-desktop

systemctl set-default multi-user.target