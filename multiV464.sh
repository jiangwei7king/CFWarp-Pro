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

function warp6(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp64(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp4(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp466(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS本地IPV6地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp4646(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu4 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu4 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu4
sed -i "s#eu4#$eu4#g" wgcf-profile.conf
sed -i '7 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '8 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS本地IPV6地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp464(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/EUserv-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
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

function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
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
echo 'DNS=9.9.9.9 8.8.8.8'>> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl enable systemd-resolved
mv /etc/resolv.conf  /etc/resolv.conf.bak
ln -s /run/systemd/resolve/resolv.conf /etc/
sudo reboot
}

function status(){
systemctl status wg-quick@wgcf
}

function up(){
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/multiX86.sh && chmod +x multiX86.sh && ./multiX86.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持KVM X86架构/Ubuntu 20.04系统，还在优化添加新功能中…… "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式 bash ~/multiV464.sh "
    
    blue " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    blue " 1. 开启甲骨文VPS的ubuntu系统所有端口。自动断连后，请重新连接SSH（甲骨文云用户建议选择！！） "
    
    blue " 2. 更新linux系统X86架构通用版内核至5.11版。自动断连后，请重新连接SSH "
    
    blue " 3. 开启原生BBR加速 "
    
    blue " 4. 检测奈飞Netflix是否解锁 "
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数--------------添加WARP虚拟IP的位置-----------是否需要输入相关IP--------------"
    
    green " 5. 单IPV4的VPS。             添加WARP虚拟IPV6               (无须输入IP地址！其他vps无脑推荐）" 
    
    green " 6. 单IPV4的VPS。             添加WARP虚拟IPV4+虚拟IPV6      (须输入VPS专用IP地址）"
    
    green " 7. 单IPV4的VPS。             添加WARP虚拟IPV4               (须输入VPS专用IP地址）"
    
    green " 8. 双栈IPV4+IPV6的VPS。      添加WARP虚拟IPV6               (须输入VPS本地IPV6地址)" 
    
    green " 9. 双栈IPV4+IPV6的VPS。      添加WARP虚拟IPV4+虚拟IPV6      (须输入VPS专用IP地址+VPS本地IPV6地址)"
    
    green " 10. 双栈IPV4+IPV6的VPS。     添加WARP虚拟IPV4               (须输入VPS专用IP地址)"
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 11. 统一DNS设置。自动断连后，请重新连接SSH（建议选择） "
    
    green " 12. 永久关闭WARP功能 "
    
    green " 13. 自动开启WARP功能 "
    
    green " 14. 查看当前WARP运行状态 "
    
    green " 15. 查看VPS当前正在使用的IPV4地址 "
    
    green " 16. 查看VPS当前正在使用的IPV6地址 "
    
    green " 17. 更新脚本 "
    
    yellow " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 18.使用mack-a脚本（支持Xray, V2ray, Trojan-go） "
    
    yellow " 19.使用phlinhng脚本（支持Xray, Trojan-go, SS+v2ray-plugin） "
    
    yellow " ==============================================================================================="
    
    red " 20. 重启VPS实例，请重新连接SSH "
    
    red " ==================================================================================================" 
    
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           iptables
	;;
	2 )
           linux5.11
	;;
        3 )
           BBR
	;;
	4 )
           Netflix
	;;    
        5 )
           warp6
	;;
        6 )
           warp64
	;;
        7 )
           warp4
	;;
        8 )
           warp466
	;;
        9 )
           warp4646
	;;
	10 )
           warp464
	;;
	11 )
           dns
	;;
	12 )
           cwarp
	;;
	13 )
           owarp
	;;
	14 )
           status
	;;
	15 )
           ipv4
	;;
	16 )
           ipv6
	;;
	17 )
           up
	;;
	18 )
           macka
	;;
	19 )
           phlinhng
	;;
	20 )
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

function warp6(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp64(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp4(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp466(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS本地IPV6地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp4646(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu4 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu4 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu4
sed -i "s#eu4#$eu4#g" wgcf-profile.conf
sed -i '7 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '8 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS本地IPV6地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp464(){
yellow " 检测当前内核版本 "
uname -r

main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`

if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，为实现WARP网络效能最高的内核集成Wireguard方案，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}


function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
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
echo 'DNS=9.9.9.9 8.8.8.8'>> /etc/systemd/resolved.conf
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

function status(){
systemctl status wg-quick@wgcf
}

function up(){
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/multiARM.sh && chmod +x multiARM.sh && ./multiARM.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持KVM ARM架构/Ubuntu 20.04系统，还在优化添加新功能中…… "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式bash ~/multiV464.sh "
    
    blue " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    blue " 1. 开启甲骨文VPS的ubuntu系统所有端口。自动断连后，请重新连接SSH（甲骨文云用户建议选择！！） "
    
    blue " 2. 更新linux系统ARM架构通用版内核至5.11版。自动断连后，请重新连接SSH "
    
    blue " 3. 开启原生BBR加速 "
    
    blue " 4. 检测奈飞Netflix是否解锁 "
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数--------------添加WARP虚拟IP的位置-----------是否需要输入相关IP--------------"
    
    green " 5. 纯IPV4的VPS。             添加WARP虚拟IPV6               (无须输入IP地址！其他vps无脑推荐）" 
    
    green " 6. 纯IPV4的VPS。             添加WARP虚拟IPV4+虚拟IPV6      (须输入VPS专用IP地址）"
    
    green " 7. 纯IPV4的VPS。             添加WARP虚拟IPV4               (须输入VPS专用IP地址）"
    
    green " 8. 双栈IPV4+IPV6的VPS。      添加WARP虚拟IPV6               (须输入VPS本地IPV6地址)" 
    
    green " 9. 双栈IPV4+IPV6的VPS。      添加WARP虚拟IPV4+虚拟IPV6      (须输入VPS专用IP地址+VPS本地IPV6地址)"
    
    green " 10. 双栈IPV4+IPV6的VPS。     添加WARP虚拟IPV4               (须输入VPS专用IP地址)"
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 11. 统一DNS设置。自动断连后，请重新连接SSH（建议选择） "
    
    green " 12. 永久关闭WARP功能 "
    
    green " 13. 自动开启WARP功能 "
    
    green " 14. 查看当前WARP运行状态 "
    
    green " 15. 查看VPS当前正在使用的IPV4地址 "
    
    green " 16. 查看VPS当前正在使用的IPV6地址 "
    
    green " 17. 更新脚本 "
    
    yellow " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 18.使用mack-a脚本（支持ARM架构VPS，支持协议：Xray, V2ray, Trojan-go） "
    
    yellow " ==============================================================================================="
    
    red " 19. 重启VPS实例，请重新连接SSH "
    
    red " ==================================================================================================" 
    
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           iptables
	;;
	2 )
           arm5.11
	;;
        3 )
           BBR
	;;
	4 )
           Netflix
	;;    
        5 )
           warp6
	;;
        6 )
           warp64
	;;
        7 )
           warp4
	;;
        8 )
           warp466
	;;
        9 )
           warp4646
	;;
	10 )
           warp464
	;;
	11 )
           dns
	;;
	12 )
           cwarp
	;;
	13 )
           owarp
	;;
	14 )
           status
	;;
	15 )
           ipv4
	;;
	16 )
           ipv6
	;;
	17 )
           up
	;;
	18 )
           macka
	;;
	19 )
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
