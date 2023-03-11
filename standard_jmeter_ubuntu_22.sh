#Install Base Binary File and Initial Configuration on UltraVNC
apt update && apt install -y \
  tigervnc-standalone-server \
  ubuntu-gnome-desktop \
  default-jdk

systemctl set-default multi-user.target