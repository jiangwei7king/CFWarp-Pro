#!/bin/bash

bit=`uname -m`
if [[ ${bit} == "x86_64" ]]; then
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



function BBR(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
curl -fsSL https://raw.staticdn.net/phlinhng/v2ray-tcp-tls-web/main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function ipv4(){
curl -4 ip.p3terx.com
}

function ipv6(){
curl -6 ip.p3terx.com
}

function Netflix(){
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.60_linux_amd64 && chmod +x nf && clear && ./nf -method full
}

function reboot(){
sudo reboot
}

function dns(){
echo 'DNS=2a00:1098:2c::1'>> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl enable systemd-resolved
mv /etc/resolv.conf  /etc/resolv.conf.bak
ln -s /run/systemd/resolve/resolv.conf /etc/
sudo reboot
}

function linux5.11(){
cd /tmp
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-headers-5.11.0-051100_5.11.0-051100.202102142330_all.deb
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-headers-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb 
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-image-unsigned-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/amd64/linux-modules-5.11.0-051100-generic_5.11.0-051100.202102142330_amd64.deb
sudo dpkg -i *.deb
reboot
}

function v646(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择1，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $(wget -qO- ipv6.ip.sb) table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $(wget -qO- ipv6.ip.sb) table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function v64(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择1，更新内核吧"
	exit 1
fi
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function status(){
systemctl status wg-quick@wgcf
}

function 6x86(){
wget -6 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6ARM.sh && chmod +x V6ARM.sh && ./V6ARM.sh
}

function 4x86(){
wget -4 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6ARM.sh && chmod +x V6ARM.sh && ./V6ARM.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持KVM X86架构的纯IPV6 /Ubuntu 20.04系统，还在优化添加新功能中…… "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式 bash ~/multiOV6.sh "
    
    blue " ==========================一、VPS状态调整选择及说明（更新中）==========================================" 
    
    blue " 1. 更新linux系统X86架构通用版内核至5.11版。自动断连后，请重新连接SSH "
    
    blue " 2. DNS64设置。自动断连后，请重新连接SSH（建议选择） "
    
    blue " 3. 开启原生BBR加速（启用WARP后可执行） "
    
    blue " 4. 检测奈飞Netflix是否解锁（启用WARP后可执行） " 
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数--------------添加WARP虚拟IP的位置-----------是否需要输入相关IP--------------"
    
    green " 5. 纯IPV6的VPS。            添加WARP虚拟IPV4+虚拟IPV6      (无须输入IP地址！)"
    
    green " 6. 纯IPV6的VPS。            添加WARP虚拟IPV4               (无须输入IP地址！)"
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 7. 永久关闭WARP功能。自动断连后，请重新连接SSH "
    
    green " 8. 自动开启WARP功能 "
    
    green " 9. 在WARP开启状态下更新脚本 "
    
    green " 10. 在WARP关闭状态下更新脚本 "
    
    green " 11. 查看当前WARP运行状态 "
    
    green " 12. 查看VPS当前正在使用的IPV4地址 "
    
    green " 13. 查看VPS当前正在使用的IPV6地址 "
    
    yellow " ==========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 14. 使用mack-a脚本（支持协议：Xray, V2ray, Trojan-go） "
    
    yellow " ==============================================================================================="
    
    red " 15. 重启VPS实例，请重新连接SSH "
    
    red " ==================================================================================================" 
    
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
	1 )
           linux5.11
	;;
	2 )
           dns
	;;
       3 )
           BBR
	;;
	4 )
           Netflix
	;;
	5 )
           v646
	;;
	6 )
           v64
	;;
	
	7 )
           cwarp
	;;
	8 )
           owarp
	;;
	9 )
           4x86
	;;
	10 )
           6x86
	;;
	11 )
           status
	;;
	12 )
           ipv4
	;;
	13 )
           ipv6
	;;
	14 )
           macka
	;;
	15 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  

elif [[ ${bit} == "aarch64" ]]; then
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



function BBR(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
curl -fsSL https://raw.staticdn.net/phlinhng/v2ray-tcp-tls-web/main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function ipv4(){
curl -4 ip.p3terx.com
}

function ipv6(){
curl -6 ip.p3terx.com
}

function Netflix(){
wget -O nf https://github.com/sjlleo/netflix-verify/releases/download/2.6/nf_2.6_linux_arm64 && chmod +x nf && clear && ./nf  -method full
}

function reboot(){
sudo reboot
}

function dns(){
echo 'DNS=2a00:1098:2c::1'>> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl enable systemd-resolved
mv /etc/resolv.conf  /etc/resolv.conf.bak
ln -s /run/systemd/resolve/resolv.conf /etc/
sudo reboot
}

function arm5.11(){
cd /tmp
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/arm64/linux-headers-5.11.0-051100-generic_5.11.0-051100.202102142330_arm64.deb
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/arm64/linux-image-unsigned-5.11.0-051100-generic_5.11.0-051100.202102142330_arm64.deb 
wget --no-check-certificate -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.11/arm64/linux-modules-5.11.0-051100-generic_5.11.0-051100.202102142330_arm64.deb
sudo dpkg -i *.deb
sudo apt -f install -y
sudo reboot
}

function v646(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择1，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/Oracle-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $(wget -qO- ipv6.ip.sb) table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $(wget -qO- ipv6.ip.sb) table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function v64(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择1，更新内核吧"
	exit 1
fi
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/Oracle-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function status(){
systemctl status wg-quick@wgcf
}

function 6arm(){
wget -6 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6ARM.sh && chmod +x V6ARM.sh && ./V6ARM.sh
}

function 4arm(){
wget -4 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6ARM.sh && chmod +x V6ARM.sh && ./V6ARM.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持KVM ARM架构的纯IPV6 /Ubuntu 20.04系统，还在优化添加新功能中…… "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式 bash ~/multiOV6.sh "
    
    blue " ==========================一、VPS状态调整选择及说明（更新中）==========================================" 
    
    blue " 1. 更新linux系统ARM架构通用版内核至5.11版。自动断连后，请重新连接SSH "
    
    blue " 2. DNS64设置。自动断连后，请重新连接SSH（建议选择） "
    
    blue " 3. 开启原生BBR加速（启用WARP后可执行） "
    
    blue " 4. 检测奈飞Netflix是否解锁（启用WARP后可执行） " 
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数--------------添加WARP虚拟IP的位置-----------是否需要输入相关IP--------------"
    
    green " 5. 纯IPV6的VPS。            添加WARP虚拟IPV4+虚拟IPV6      (无须输入IP地址！)"
    
    green " 6. 纯IPV6的VPS。            添加WARP虚拟IPV4               (无须输入IP地址！)"
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 7. 永久关闭WARP功能。自动断连后，请重新连接SSH "
    
    green " 8. 自动开启WARP功能 "
    
    green " 9. 在WARP开启状态下更新脚本 "
    
    green " 10. 在WARP关闭状态下更新脚本 "
    
    green " 11. 查看当前WARP运行状态 "
    
    green " 12. 查看VPS当前正在使用的IPV4地址 "
    
    green " 13. 查看VPS当前正在使用的IPV6地址 "
    
    yellow " =====================三、支持ARM架构的代理协议脚本选择（更新中）==========================================="
    
    yellow " 14.使用mack-a脚本（支持协议：Xray, V2ray, Trojan-go） "
    
    yellow " ==============================================================================================="
    
    red " 15. 重启VPS实例，请重新连接SSH "
    
    red " ==================================================================================================" 
    
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
	1 )
           arm5.11
	;;
	2 )
           dns
	;;
	3 )
           BBR
	;;
	4 )
           Netflix
	;;
	5 )
           v646
	;;
	6 )
           v64
	;;	
	7 )
           cwarp
	;;
	8 )
           owarp
	;;
	9 )
           4arm
	;;
	10 )
           6arm
	;;
	11 )
           status
	;;
	12 )
           ipv4
	;;
	13 )
           ipv6
	;;
	14 )
           macka
	;;
	15 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  

else
 echo "此CPU架构不是X86,也不是ARM！不支持！"
 exit
fi
