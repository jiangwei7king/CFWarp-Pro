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
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}

bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}

rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
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
rv4=`ip a | grep 'brd' | awk 'NR==3 {print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`
op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`hostnamectl | grep -i Virtualization | awk -F ':' '{print $2}'`

if [[ ${vi} == " kvm" ]]; then
green " ---VPS扫描中---> "

elif [[ ${vi} == " xen" ]]; then
green " ---VPS扫描中---> "

elif [[ ${vi} == " microsoft" ]]; then
green " ---VPS扫描中---> "

else
yellow " 虚拟架构类型 - $vi "
yellow " 对此vps架构不支持，脚本安装自动退出！"
exit 1
fi

if [[ ${bit} == "x86_64" ]]; then

function wo646(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP,则说明失败喽！！ "
}

function wo66(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/9.9.9.9,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf*
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功！\n 如上方无IP显示，则说明失败喽！ "
}

function wo64(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function warp6(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
sudo chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV6地址：2a09:…………，则说明成功！\n 如上方无IP显示，则说明失败喽！ "
}

function warp64(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP，则说明失败喽！！ "
}

function warp4(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function warp466(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,则说明失败喽！ "
}

function warp4646(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP，则说明失败喽！ "
}

function warp464(){
yellow " 检测系统内核版本是否大于5.6版本 "
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，自动更新内核吧"
	exit 1
fi

if [ $release = "Centos" ]
	then
	        yum update -y
                yum install curl wget -y && yum install sudo -y
		yum install epel-release -y		
		yum install -y \
                https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
                curl -o /etc/yum.repos.d/jdoss-wireguard-epel-7.repo \
                https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
                yum install wireguard-tools -y
	elif [ $release = "Debian" ]
	then
		apt-get update -y
		apt-get install curl wget -y && apt install sudo -y
		apt-get install openresolv -y
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
		apt-get install linux-headers-`uname -r` -y
		apt-get install wireguard-tools -y
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y
		apt-get install curl wget -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	else
		yellow " 不支持当前系统 "
		exit 1
	fi
wget -N https://github.com/ViRb3/wgcf/releases/download/v2.2.3/wgcf_2.2.3_linux_amd64 -O /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function upcore(){
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/CFWarp-Pro/main/upcore.sh&& chmod +x upcore.sh && ./upcore.sh
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
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
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
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
curl -fsSL https://raw.staticdn.net/phlinhng/v2ray-tcp-tls-web/main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function cv46(){
        yellow "开始检测IPV4地址"
	v4=`wget -qO- ipv4.ip.sb`
	pingv4=$(ping -c 1 www.google.com| sed '2{s/[^(]*(//;s/).*//;q;}' | tail -n +2) 
        if [[ -z "${pingv4}" ]]; then 
        red " ---> VPS当前检测不到IPV4地址 " 
	else
	green " VPS当前正使用的IPV4地址: $v4 "
	fi
	
	
	yellow "开始检测IPV6地址"
	v6=`wget -qO- ipv6.ip.sb`
	pingv6=$(ping6 -c 1 www.google.com| sed '2{s/[^(]*(//;s/).*//;q;}' | tail -n +2) 
	if [[ -z "${pingv6}" ]]; then 
        red " ---> VPS当前检测不到IPV6地址 " 
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

function up6(){
echo -e nameserver 2a00:1098:2c::1 > /etc/resolv.conf
wget -6 -N --no-check-certificate https://cdn.jsdelivr.net/gh/YG-tsj/CFWarp-Pro/multi.sh && chmod +x multi.sh && ./multi.sh
}

function up4(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/YG-tsj/CFWarp-Pro/multi.sh && chmod +x multi.sh && ./multi.sh
}

#主菜单
function start_menu(){
    clear
    yellow " VPS相关信息如下："
    white "------------------------------------------"
    blue " 操作系统名称 -$op "
    blue " 系统内核版本 - $version " 
    blue " CPU架构名称  - $bit "
    blue " 虚拟架构类型 -$vi "
    white " -----------------------------------------------" 
    yellow " 详细说明 https://github.com/YG-tsj/CFWarp-Pro  YouTube频道：甬哥探世界 " 
    
    red " 切记：进入脚本快捷方式 bash multi.sh "
    
    white " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    green " 1. 永久开启甲骨文VPS的ubuntu系统所有端口（甲骨文云用户建议选择！！） "
    
    green " 2. 更新系统内核 "
    
    green " 3. 开启原生BBR加速 "
    
    green " 4. 检测奈飞Netflix是否解锁 "
    
    white " =========================二、WARP功能选择（更新中）=============================================="
    
    yellow " ----VPS原生IP数------------------------------------添加WARP虚拟IP的位置--------------"
    
    green " 5. 纯IPV4的VPS。                                   添加WARP虚拟IPV6               "
    
    green " 6. 纯IPV4的VPS。                                   添加WARP虚拟IPV4+虚拟IPV6      "
    
    green " 7. 纯IPV4的VPS。                                   添加WARP虚拟IPV4              "
    
    green " 8. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV6               "
    
    green " 9. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV4+虚拟IPV6      "
    
    green " 10. 双栈IPV4+IPV6的VPS。                           添加WARP虚拟IPV4               "
    
    green " 11. 纯IPV6的VPS。                                  添加WARP虚拟IPV6               "
    
    green " 12. 纯IPV6的VPS。                                  添加WARP虚拟IPV4+虚拟IPV6       "
    
    green " 13. 纯IPV6的VPS。                                  添加WARP虚拟IPV4               "
    
    white " ------------------------------------------------------------------------------------------------"
    
    green " 14. 永久关闭WARP功能 "
    
    green " 15. 自动开启WARP功能 "
    
    green " 16. 查看当前WARP运行状态 "
    
    green " 17. 查看VPS当前正在使用的IPV4/IPV6地址 "
    
    green " 18. 纯V6下更新脚本 "
    
    green " 19. 纯V4/V4+V6下更新脚本 "
    
    white " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 以下脚本已添加全端口临时开启功能，重启VPS实例可自动还原初始设置 "
    
    green " 19.使用mack-a脚本（支持Xray, V2ray, Trojan-go） "
    
    green " 20.使用phlinhng脚本（支持Xray, Trojan-go, SS+v2ray-plugin） "
    
    white " ==============================================================================================="
    
    green " 21. 重启VPS实例，请重新连接SSH "
    
    white " ==================================================================================================" 
    
    green " 0. 退出脚本 "
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
           wo66
	;;
	12 )
           wo646
	;;
	13 )
           wo64
	;;
	14 )
           cwarp
	;;
	15 )
           owarp
	;;
	16 )
           status
	;;
	17 )
           cv46
	;;
	18 )
           up6
	;;
	19 )
           up4
	;;
	20 )
           macka
	;;
	21 )
           phlinhng
	;;
	22 )
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
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,则说明失败喽！ "
}

function warp64(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP，则说明失败喽！ "
}

function warp4(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
}

function warp466(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,则说明失败喽！ "
}

function warp4646(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP，则说明失败喽！ "
}

function warp464(){
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
	red " 检测到内核版本小于5.6，回到菜单，选择2，更新内核吧"
	exit 1
fi

apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://github.com/YG-tsj/CFWarp-Pro/raw/main/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
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
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方显示VPS本地IP,则说明失败喽！ "
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
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
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
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
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
wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/CFWarp-Pro/main/multi.sh && chmod +x multi.sh && ./multi.sh
}

#主菜单
function start_menu(){
    clear
    yellow " VPS相关信息如下："
    white "------------------------------------------"
    blue " 操作系统名称 -$op "
    blue " 系统内核版本 - $version " 
    blue " CPU架构名称  - $bit "
    blue " 虚拟架构类型 -$vi "
    white " -----------------------------------------------" 
    yellow " 详细说明 https://github.com/YG-tsj/CFWarp-Pro  YouTube频道：甬哥探世界 " 
    
    red " 切记：进入脚本快捷方式 bash multi.sh "
    
    white " ==========================一、VPS状态调整选择（更新中）==========================================" 
    
    green " 1. 永久开启甲骨文VPS的ubuntu系统所有端口（甲骨文云用户建议选择！！） "
    
    green " 2. 更新ARM架构通用版内核至5.11版 "
    
    green " 3. 开启原生BBR加速 "
    
    green " 4. 检测奈飞Netflix是否解锁 "
    
    white " =========================二、WARP功能选择（更新中）=============================================="
    
    white " ----VPS原生IP数-------------------------------------添加WARP虚拟IP的位置----------"
    
    green " 5. 纯IPV4的VPS。                                    添加WARP虚拟IPV6          "     
    
    green " 6. 纯IPV4的VPS。                                    添加WARP虚拟IPV4+虚拟IPV6  "   
    
    green " 7. 纯IPV4的VPS。                                    添加WARP虚拟IPV4            "  
    
    green " 8. 双栈IPV4+IPV6的VPS。                             添加WARP虚拟IPV6             " 
    
    green " 9. 双栈IPV4+IPV6的VPS。                             添加WARP虚拟IPV4+虚拟IPV6     " 
    
    green " 10. 双栈IPV4+IPV6的VPS。                            添加WARP虚拟IPV4               "
    
    white " ------------------------------------------------------------------------------------------------"
    
    green " 11. 永久关闭WARP功能 "
    
    green " 12. 自动开启WARP功能 "
    
    green " 13. 查看当前WARP运行状态 "
    
    green " 14. 查看VPS当前正在使用的IPV4/IPV6地址 "
    
    green " 15. 更新脚本 "
    
    white " ========================三、代理协议脚本选择（更新中）==========================================="
    
    yellow " 以下脚本已添加全端口临时开启功能，重启VPS实例可还原初始设置 "
    
    green " 16.使用mack-a脚本（支持ARM架构VPS，支持协议：Xray, V2ray, Trojan-go） "
    
    white " ==============================================================================================="
    
    green " 17. 重启VPS实例，请重新连接SSH "
    
    white " ==================================================================================================" 
    
    green " 0. 退出脚本 "
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
