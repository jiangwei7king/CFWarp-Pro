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

yum install virt-what

bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
virt=`virt-what`

yellow " VPS小鸡内脏检测结果如下："

yellow " 系统内核版本 - $version " 
yellow " CPU架构名称 - $bit "
yellow " 虚拟架构类型 - $virt "

sleep 3s

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

function start_menu(){
    clear
    red " 更新Centos系统内核到最新版本 " 
    blue " 1. Centos7 "    
    blue " 2. Centos8 "
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
     0 )
       exit 1
	   ;;
      esac
}

start_menu "first"  
