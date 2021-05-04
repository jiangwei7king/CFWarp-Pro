sudo sed -i '$a echo root:mima | sudo chpasswd root' /etc/cloud/cloud.cfg
sudo echo "sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;" >> /etc/cloud/cloud.cfg
sudo echo "sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;" >> /etc/cloud/cloud.cfg
sudo sed -i '$a sudo service sshd restart' /etc/cloud/cloud.cfg
read -p "自定义ROOT密码:" mima
sudo sed -i "s#mima#$mima#g" /etc/cloud/cloud.cfg
echo root:$mima | sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo service sshd restart
sudo reboot
