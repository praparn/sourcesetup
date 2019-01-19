#Install Base Binary File and Initial Configuration on UltraVNC
sudo apt update && apt install -y \
  ubuntu-desktop \
  vnc4server \
  gnome-panel \
  gnome-settings-daemon \
  metacity \
  nautilus \
  gnome-terminal \
  jmeter

sudo mkdir /home/ubuntu/.vnc
curl https://raw.githubusercontent.com/praparn/sourcesetup/master/xstartup > /home/ubuntu/.vnc/xstartup

#Install Jmeter Binary and Lastest File

curl https://www-us.apache.org/dist//jmeter/binaries/apache-jmeter-5.0.tgz > /home/ubuntu/apache-jmeter-5.0.tgz
  tar -xf /home/ubuntu/apache-jmeter-5.0.tgz
  cd apache-jmeter-5.0/bin/
#restart
#reboot