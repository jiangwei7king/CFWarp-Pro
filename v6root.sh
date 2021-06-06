#!/bin/bash

sudo lsattr /etc/passwd /etc/shadow
sudo chattr -i /etc/passwd /etc/shadow
sudo chattr -a /etc/passwd /etc/shadow
sudo lsattr /etc/passwd /etc/shadow

echo 'DNS=2a00:1098:2c::1'>> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl enable systemd-resolved
mv /etc/resolv.conf  /etc/resolv.conf.bak
ln -s /run/systemd/resolve/resolv.conf /etc/

read -p "自定义ROOT密码:" mima
echo root:$mima | sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
sudo reboot
