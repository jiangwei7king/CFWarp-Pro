#!/bin/bash

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
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp6* wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
}

function warp64(){
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp64* wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
}

function warp4(){
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
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
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp4* wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
}

function warp466(){
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS本地IPV6地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp466* wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
}

function warp4646(){
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
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
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp4646* wgcf*
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
}

function warp464(){
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N -4 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（VPS专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8,2001:4860:4860::8888,2001:4860:4860::8844/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp464* wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ "
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
rm -rf /etc/iptables && reboot
}

function BBR(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}

function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
green " 检测是否成功关闭Warp！请对照下方显示的IP地址是否与VPS本地的IP地址是否一致，如相同则成功关闭！ \n 当前IPV4地址：$(wget -qO- ipv4.ip.sb) 当前IPV6地址：$(wget -qO- ipv6.ip.sb) "
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
green " 检测是否成功启动Warp！如下方显示为IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功启动！\n 当前IPV4地址：$(wget -qO- ipv4.ip.sb) 当前IPV6地址：$(wget -qO- ipv6.ip.sb) "
}

function macka(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
curl -fsSL https://raw.staticdn.net/phlinhng/v2ray-tcp-tls-web/main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function ip(){
wget -qO- ipv4.ip.sb
wget -qO- ipv6.ip.sb
}

function Netflix(){
apt update && snap install jq && bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Netflix-Check/main/V4V6.sh)
}


#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持Ubuntu 20.04系统，Linux系统内核必须5.6以上，还在优化更新中…… "  
    
    red " ====================================================" 
    
    blue " 1. 开启甲骨文VPS的ubuntu系统所有端口，自动断连后，请重新连接SSH（仅适用于甲骨文云） "
    
    blue " 2. 更新linux系统通用版内核至5.11版，自动断连后，请重新连接SSH "
    
    blue " 3. 启用teddysun版通用BBR加速 按任意键即可安装成功 "
    
    blue " 4. 检测奈非Netflix是否解锁 "
    
    blue " =================================================="
    
    green " 5. 仅适用于单IPV4的VPS。         添加WARP分配的IPV6       (无须输入IP地址！其他vps推荐）" 
    
    green " 6. 仅适用于单IPV4的VPS。         添加WARP分配的IPV6与IPV4 (须输入VPS专用IP地址）"
    
    green " 7. 仅适用于单IPV4的VPS。         添加WARP分配的IPV4       (须输入VPS专用IP地址）"
    
    green " 8. 仅适用于双栈IPV4+IPV6的VPS。  添加WARP分配的IPV6       (须输入VPS本地IPV6地址)" 
    
    green " 9. 仅适用于双栈IPV4+IPV6的VPS。  添加WARP分配的IPV6与IPV4 (须输入VPS专用IP地址+VPS本地IPV6地址)"
    
    green " 10. 仅适用于双栈IPV4+IPV6的VPS。  添加WARP分配的IPV4      (须输入VPS专用IP地址)"
    
    green " 11. 关闭WARP功能 "
    
    green " 12. 开启WARP功能 "
    
    green " 13. 查看VPS当前正在使用的IPV4/IPV6地址 "
    
    green " =================================================="
    
    yellow " 14.使用mack-a脚本（Xray,V2ray,Trojan-go） "
    
    yellow " 15.使用phlinhng脚本（Xray,Trojan-go,SS+v2ray-plugin） "
    
    yellow " =================================================="
    
    red " 0. 退出脚本"
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
           cwarp
	;;
	12 )
           owarp
	;;
	13 )
           ip
	;;
	14 )
           macka
	;;
	15 )
           phlinhng
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  
