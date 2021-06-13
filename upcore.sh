#!/usr/bin/env bash

#彩色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}

function c8(){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm -y
yum --enablerepo=elrepo-kernel install kernel-ml -y
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
}

function c7(){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm -y
yum --enablerepo=elrepo-kernel install kernel-ml -y
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
}

function ub(){
cd /tmp
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-headers-5.11.0-051100_5.11.0-051100.202102142330_all.deb
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-headers-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb 
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-image-unsigned-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-modules-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb
sudo dpkg -i *.deb
reboot
}

function de(){
apt -t buster-backports install linux-image-amd64 -y
apt -t buster-backports install linux-headers-amd64 -y
update-grub
reboot
}

function start_menu(){
    clear
    green " 更新系统内核到官方源最新版本！注意，别手滑哦！" 
    blue " 1. Centos7 "    
    blue " 2. Centos8 "
    blue " 3. Ubuntu "
    blue " 4. Debain "
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in   
     1 )
        c7
     ;;
     2 )
        c8
     ;;
     3 )
        ub
     ;;
     4 )
        de
     ;;
     0 )
       exit 1
     ;;
      esac
}

start_menu "first"  
