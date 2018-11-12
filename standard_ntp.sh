#!/usr/bin/env bash

#Set LC_ALL, LANG
sudo timedatectl set-timezone Asia/Bangkok
sudo apt install -y chrony
sudo sed -i -e 's/pool 2.debian.pool.ntp.org offline iburst/server time.navy.mi.th prefer iburst/g' /etc/chrony/chrony.conf
sudo /etc/init.d/chrony restart
#chronyc sources -v
#restart
#reboot