echo -e "\033[1;36m 请 注 意！脚 本 仅 支 持 Ubuntu 系 统，且 内 核 5.6 版 本 以 上！\n 针对KVM架构的IPV4 only VPS！！！双栈Warp接管IPV4与IPV6网络！！！ \033[0m"
apt update 
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -4 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -4 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
echo -e "\033[1;33m 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- ipv4.ip.sb) 显示IPV6地址：$(wget -qO- ipv6.ip.sb) \033[0m"
echo -e "\033[1;32m 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示,IPV6显示本地IP（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ \033[0m"

