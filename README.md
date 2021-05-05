### Oracle甲骨文脚本集合，针对KVM架构IPV4 ONLY VPS，

### 本项目Youtube视频教程：https://youtu.be/o7e_ikV-m-g

### EUserv ipv6的(OpenVZ、LXC架构VPS)WARP项目:https://github.com/YG-tsj/EUserv-warp

### 给ipv4 only VPS添加WARP的好处：

1：使只有IPV4的VPS获取访问IPV6的能力，套上WARP的ip，变成双栈VPS！

2：基本能隐藏VPS的真实IP！

3：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

4：加速VPS到CloudFlare CDN节点访问速度！

5：避开原VPS的IP需要谷歌验证码问题！

6：WARP的IPV6替代HE tunnelbroker IPV6的隧道代理方案，做IPV6 VPS跳板机代理更加稳定、高效！

--------------------------------------------------------------------------------------------------------
### 一：设置Root密码一键脚本（默认ROOT权限，方便登录与编辑文件）（KVM架构VPS通用）！！

```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
-----------------------------------------------------------------------------------------------------
### 二：更新甲骨文Ubuntu系统内核一键脚本（KVM架构VPS通用）

#### 目前甲骨文Ubuntu20.04系统内核为5.4版本（查看内核版本```uname -r```），而5.6版本以上内核才集成Wireguard，内核集成方案在理论上网络效率最高！（网络性能：内核集成>内核模块>Wireguard-Go）

#### 任选以下两个内核脚本中的一个进行升级，都集成删除iptables的代码```rm -rf /etc/iptables && reboot```，解决甲骨文Ubuntu系统类似Nginx等证书申请报错问题！

### 1、通用内核5.11版本（推荐：通用稳定版，后续会更新）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/generic-kernel.sh)
```
### 2、第三方xanmod内核（安装时自动安装最新版本）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/xanmod-kernel.sh)
```
-------------------------------------------------------------------------------------------------------------
### 三：开启BBR加速（秋水逸冰大老-传统版，KVM架构VPS通用）
```
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```
#### 检测BBR是否生效(显示有BBR，说明成功)：```lsmod | grep bbr```
-------------------------------------------------------------------------------------------------------------
### 四：重装系统能解决99%的问题，WARP三种情况最全脚本集合

#### 仅支持Ubuntu 20.04系统，系统内核5.6以上！根据自己需求选择脚本1、脚本2或者脚本3（有无成功可查看脚本末尾提示）

#### (双栈IPV4+IPV6)脚本1：IPV4是VPS本地IP，IPV6是WARP分配的IP
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/warp6.sh)
```
#### (双栈IPV4+IPV6)脚本2：IPV4与IPV6都是WARP分配的IP
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/warp64.sh)
```
#### (单IPV4)脚本3：IPV4是WARP分配的IP，无IPV6（不支持IPV6 VPS跳板机）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/warp4.sh)
```
### 注意：域名解析所填写的IP必须是VPS本地IP，与WARP分配的IP没关系！

### 推荐使用Xray脚本项目（mack-a）：https://github.com/mack-a/v2ray-agent

-------------------------------------------------------------------------------------------
### 其他KVM架构VPS查看专用ip方式（待更新）
脚本1不用输入专用IP。脚本2与3需要输入专用IP（防止VPS本地IP套WARP后失联），根据不同的VPS，专用IP可能是IP，也可能是IP段。

进入SSH查看专用IP命令：```ip -4 route```或者```ip addr```

结果会显示IP或者IP段，IP段用 /数字 表示！

例：有的VPS公网IP为123.456.2.3，而专用IP段可能就是123.456.0.1/16，此时，要输入的专用IP就是123.456.0.1/16，别忘记输入后面的/16哦！

具体大家可以自己尝试，输错了可能导致VPS失联，也就那几个IP或者IP段，。

-------------------------------------------------------------------------------------------------------------
#### Netflix检测项目：https://github.com/YG-tsj/Netflix-Check

#### 提示：配置文件wgcf.conf和注册文件wgcf-account.toml都已备份在/etc/wireguard目录下！

----------------------------------------------------------------------------------------------------
##### 查看WARP当前统计状态：```wg```

-------------------------------------------------------------------------------------------------------------

##### IPV4 VPS WARP专用分流配置文件(以下默认全局IPV4优先，IP、域名自定义教程，参考https://youtu.be/fY9HDLJ7mnM)
```
{ 
"outbounds": [
    {
      "tag":"IP4-out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag":"IP6-out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6" 
      }
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP4-out",
        "domain": [""] 
      },
      {
        "type": "field",
        "outboundTag": "IP6-out",
        "network": "udp,tcp" 
      }
    ]
  }
}
``` 
-----------------------------------------------------------------------------------------------
#### 相关WARP进程命令

手动临时关闭WARP网络接口
```
wg-quick down wgcf
```
手动开启WARP网络接口 
```
wg-quick up wgcf
```

启动systemctl enable wg-quick@wgcf

开始systemctl start wg-quick@wgcf

重启systemctl restart wg-quick@wgcf

停止systemctl stop wg-quick@wgcf

关闭systemctl disable wg-quick@wgcf


---------------------------------------------------------------------------------------------------------------------

感谢P3terx大及原创者们，参考来源：
 
https://p3terx.com/archives/debian-linux-vps-server-wireguard-installation-tutorial.html

https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html

https://luotianyi.vc/5252.html

https://hiram.wang/cloudflare-wrap-vps/
