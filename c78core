#!/usr/bin/env bash

yellow " 安装相关依赖："
apt update
apt install sudo -y && apt install curl wget -y
apt install virt-what

bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
virt=`virt-what`

yellow " VPS小鸡内脏检测结果如下："

yellow " 系统内核版本 - $version " 
yellow " CPU架构名称 - $bit "
yellow " 虚拟架构类型 - $virt-what "

function 8(){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
}

function 7(){
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml
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
        7
	   ;;
	   2 )
        8
	   ;;
     0 )
       exit 1
	   ;;
      esac
}


start_menu "first"
