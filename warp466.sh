echo -e "\033[1;36m 请 注 意！脚 本 仅 支 持 Ubuntu20 系 统，且 内 核 5.6 版 本 以 上！\n 针对KVM架构的IPV4 only VPS！！！Warp仅接管IPV6网络！！！ \033[0m"
apt update
apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
wget -N https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf
cp wgcf /usr/local/bin/wgcf
chmod +x /usr/local/bin/wgcf
echo | wgcf register
wgcf generate
sed -i '5 s/^/PostUp = ip -6 rule add from eu6 table main\n/' wgcf-profile.conf
sed -i '6 s/^/PostDown = ip -6 rule delete from eu6 table main\n/' wgcf-profile.conf
read -p "粘贴（专用IP地址）:" eu6
sed -i "s#eu6#$eu6#g" wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f warp6* wgcf*
echo -e "\033[1;33m 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- ipv6.ip.sb) \033[0m"
echo -e "\033[1;32m 如上方显示IPV6地址：2a09:…………，则说明成功啦！\n 如上方无IP显示,（说明申请WGCF账户失败），请“无限”重复运行该脚本吧，直到成功为止！！！ \033[0m"
