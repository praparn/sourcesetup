#!/bin/bash
sudo apt update -y 
sudo apt install wget -y
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
wget https://wichawit-sample.s3-ap-northeast-1.amazonaws.com/linux-cwagentlog.json
sudo dpkg -i ./amazon-cloudwatch-agent.deb
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:linux-cwagentlog.json -s