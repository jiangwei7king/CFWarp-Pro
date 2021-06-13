#!/usr/bin/env bash
export PATH=$PATH:/usr/local/bin

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

get_char(){
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

	if [[ -f /etc/redhat-release ]]; then
		release="Centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
    fi


bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
rv4=`ip -4 a | grep inet | grep -v 127.0.0 | awk '{print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`


yellow " 安装相关依赖："
if [ $release = "Centos" ]
 then
yum update -y
yum install curl wget -y && yum install sudo -y
yum install virt-what

virt=`virt-what`
if [[ ${virt} == "kvm" ]]; then
echo "ok"
else
yellow " 虚拟架构类型 - $virt "
yellow " 此vps并非kvm架构，脚本安装自动退出！"
 exit 1
fi

 elif [ $release = "Debian" ]
 then
apt-get update -y
apt-get install curl wget -y && apt install sudo -y
apt-get install virt-what

virt=`virt-what`
if [[ ${virt} == "kvm" ]]; then
echo "ok"
else
yellow " 虚拟架构类型 - $virt "
yellow " 此vps并非kvm架构，脚本安装自动退出！"
 exit 1
fi

 elif [ $release = "Ubuntu" ]
 then
apt-get update -y
apt-get install curl wget -y &&  apt install sudo -y
apt-get install virt-what

virt=`virt-what`
if [[ ${virt} == "kvm" ]]; then
echo "ok"
else
yellow " 虚拟架构类型 - $virt "
yellow " 此vps并非kvm架构，脚本安装自动退出！"
 exit 1
fi

 else
  yellow " 不支持当前系统 "
  exit 1
 fi


yellow " VPS小鸡内脏检测结果如下！："
yellow "------------------------------------------"
green " 操作系统名称 - $release "
green " 系统内核版本 - $version " 
green " CPU架构名称  - $bit "
green " 虚拟架构类型 - $virt "
green " -----------------------------------------------"
blue " 本warp多功能脚本仅支持网络效能最高的-内-核-集-成-模式 "
blue " 要求系统内核必须在5.6以上（脚本包含更新内核功能） "

red " 对此无压力的请按：任意键继续。对此没兴趣的请按：Ctrl+C退出。 "
char=$(get_char)


if [[ ${bit} == "x86_64" ]]; then

function warp6(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sudo sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
sudo sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sudo sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
sudo cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
sudo cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请继续运行该脚本吧，直到成功为止！！！ "
}

function warp64(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
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
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i "7 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "8 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
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
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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

function upcore(){
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Pro-warp/main/upcore.sh&& chmod +x upcore.sh && ./upcore.sh
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

function cv46(){
        yellow "开始检测IPV4地址"
	v4=`wget -qO- ipv4.ip.sb`
	if [[ -z $v4 ]]; then
		red " VPS当前检测不到IPV4地址 "
	else
		green " VPS当前正使用的IPV4地址: $v4 "
	fi
	yellow "开始检测IPV6地址"
	v6=`wget -qO- ipv6.ip.sb`
	if [[ -z $v6 ]]; then
		red " VPS当前检测不到IPV6地址 "
	else
		green " VPS当前正使用的IPV6地址: $v6 "
	fi
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
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Pro-warp/main/multi.sh && chmod +x multi.sh && ./multi.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，支持KVM X86架构的Ubuntu/Centos/Debain最新系统 "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式 bash ~/multi.sh "
    
    blue " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    blue " 1. 开启甲骨文VPS的ubuntu系统所有端口。自动断连后，请重新连接SSH（甲骨文云用户建议选择！！） "
    
    blue " 2. 更新系统内核 "
    
    blue " 3. 开启原生BBR加速 "
    
    blue " 4. 检测奈飞Netflix是否解锁 "
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数------------------------------------添加WARP虚拟IP的位置--------------"
    
    green " 5. 单IPV4的VPS。                                   添加WARP虚拟IPV6               "
    
    green " 6. 单IPV4的VPS。                                   添加WARP虚拟IPV4+虚拟IPV6      "
    
    green " 7. 单IPV4的VPS。                                   添加WARP虚拟IPV4              "
    
    green " 8. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV6               "
    
    green " 9. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV4+虚拟IPV6      "
    
    green " 10. 双栈IPV4+IPV6的VPS。                           添加WARP虚拟IPV4               "
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 11. 永久关闭WARP功能 "
    
    green " 12. 自动开启WARP功能 "
    
    green " 13. 查看当前WARP运行状态 "
    
    green " 14. 查看VPS当前正在使用的IPV4/IPV6地址 "
    
    green " 15. 更新脚本 "
    
    yellow " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 16.使用mack-a脚本（支持Xray, V2ray, Trojan-go） "
    
    yellow " 17.使用phlinhng脚本（支持Xray, Trojan-go, SS+v2ray-plugin） "
    
    yellow " ==============================================================================================="
    
    red " 18. 重启VPS实例，请重新连接SSH "
    
    red " ==================================================================================================" 
    
    red " 0. 退出脚本 "
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           iptables
	;;
	2 )
           upcore
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
           status
	;;
	14 )
           cv46
	;;
	15 )
           up
	;;
	16 )
           macka
	;;
	17 )
           phlinhng
	;;
	18 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  

elif [[ ${bit} == "aarch64" ]]; then

function warp6(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
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
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
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
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
sed -i "7 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "8 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
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
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/Oracle-warp/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i "5 s/^/PostUp = ip -4 rule add from $rv4 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -4 rule delete from $rv4 table main\n/" wgcf-profile.conf
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

function cv46(){
        yellow "开始检测IPV4地址"
	v4=`wget -qO- ipv4.ip.sb`
	if [[ -z $v4 ]]; then
		red " VPS当前检测不到IPV4地址 "
	else
		green " VPS当前正使用的IPV4地址: $v4 "
	fi
	yellow "开始检测IPV6地址"
	v6=`wget -qO- ipv6.ip.sb`
	if [[ -z $v6 ]]; then
		red " VPS当前检测不到IPV6地址 "
	else
		green " VPS当前正使用的IPV6地址: $v6 "
	fi
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
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Pro-warp/main/multi.sh && chmod +x multi.sh && ./multi.sh
}

#主菜单
function start_menu(){
    clear
    red " 详细说明 https://github.com/YG-tsj/Oracle-warp  YouTube频道：甬哥探世界 " 
    
    red " 围绕WARP功能的脚本，目前仅支持甲骨文KVM ARM架构/Ubuntu 20.04系统，还在优化添加新功能中…… "  
    
    red " ==============================================================================================" 
    
    yellow " 切记：进入脚本快捷方式bash ~/multi.sh "
    
    blue " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    blue " 1. 开启甲骨文VPS的ubuntu系统所有端口。自动断连后，请重新连接SSH（甲骨文云用户建议选择！！） "
    
    blue " 2. 更新ARM架构通用版内核至5.11版。自动断连后，请重新连接SSH "
    
    blue " 3. 开启原生BBR加速 "
    
    blue " 4. 检测奈飞Netflix是否解锁 "
    
    green " =========================二、WARP功能选择（更新中）=============================================="
    
    green " ----VPS原生IP数-------------------------------------添加WARP虚拟IP的位置----------"
    
    green " 5. 纯IPV4的VPS。                                    添加WARP虚拟IPV6          "     
    
    green " 6. 纯IPV4的VPS。                                    添加WARP虚拟IPV4+虚拟IPV6  "   
    
    green " 7. 纯IPV4的VPS。                                    添加WARP虚拟IPV4            "  
    
    green " 8. 双栈IPV4+IPV6的VPS。                             添加WARP虚拟IPV6             " 
    
    green " 9. 双栈IPV4+IPV6的VPS。                             添加WARP虚拟IPV4+虚拟IPV6     " 
    
    green " 10. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV4               "
    
    green " ------------------------------------------------------------------------------------------------"
    
    green " 11. 永久关闭WARP功能 "
    
    green " 12. 自动开启WARP功能 "
    
    green " 13. 查看当前WARP运行状态 "
    
    green " 14. 查看VPS当前正在使用的IPV4/IPV6地址 "
    
    green " 15. 更新脚本 "
    
    yellow " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 16.使用mack-a脚本（支持ARM架构VPS，支持协议：Xray, V2ray, Trojan-go） "
    
    yellow " ==============================================================================================="
    
    red " 17. 重启VPS实例，请重新连接SSH "
    
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
           cwarp
	;;
	12 )
           owarp
	;;
	13 )
           status
	;;
	14 )
           cv46
	;;
	15 )
           up
	;;
	16 )
           macka
	;;
	17 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  

else
 yellow "此CPU架构不是X86,也不是ARM！奥特曼架构？"
 exit 1
fi
