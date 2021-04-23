#!/usr/bin/env bash

#Set LC_ALL, LANG
sudo timedatectl set-timezone Asia/Bangkok
sudo apt install -y chrony
sudo sed -i -e 's/pool ntp.ubuntu.com        iburst maxsources 4//g' /etc/chrony/chrony.conf
sudo sed -i -e 's/pool 0.ubuntu.pool.ntp.org iburst maxsources 1//g' /etc/chrony/chrony.conf
sudo sed -i -e 's/pool 1.ubuntu.pool.ntp.org iburst maxsources 1//g' /etc/chrony/chrony.conf
sudo sed -i -e 's/pool 2.ubuntu.pool.ntp.org iburst maxsources 2/server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4/g' /etc/chrony/chrony.conf
sudo /etc/init.d/chrony restart
#chronyc sources -v
#restart
#reboot