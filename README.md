### Oracle甲骨文脚本集合，针对KVM架构IPV4 only VPS与IPV4+IPV6真双栈VPS。

### 本项目IPV4 only VPS的Youtube视频教程：https://youtu.be/o7e_ikV-m-g

### IPV4+IPV6真双栈VPS视频教程：下期更新。。。。。。。。

### EUserv ipv6的(OpenVZ、LXC架构VPS)WARP项目:https://github.com/YG-tsj/EUserv-warp


---------------------------------------------------------------------------------------------------------------
### 给ipv4 only VPS添加WARP的好处：

1：使只有IPV4的VPS获取访问IPV6的能力，套上WARP的ip，变成双栈VPS！

2：基本能隐藏VPS的真实IP！

3：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

4：加速VPS到CloudFlare CDN节点访问速度！

5：避开原VPS的IP需要谷歌验证码问题！

6：WARP的IPV6替代HE tunnelbroker IPV6的隧道代理方案，做IPV6 VPS跳板机代理更加稳定、高效！

### 给ipv4+ipv6真双栈VPS添加WARP的好处：

1：基本能隐藏VPS的真实IP！

2：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

3：加速VPS到CloudFlare CDN节点访问速度！

4：避开原VPS的IP需要谷歌验证码问题！

--------------------------------------------------------------------------------------------------------
### 可选：设置Root密码一键脚本（用户名：root，密码自定义。方便登录与编辑文件）（KVM架构VPS通用）！！
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
-----------------------------------------------------------------------------------------------------
### 整合WARP及其他多功能！多功能一键脚本(功能继续添加中……)：

 ```
 wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/multi.sh && chmod +x multi.sh && ./multi.sh
 ```

#### 进入脚本快捷方式
```
bash ~/multi.sh
```
--------------------------------------------------------------------------------------------------
### 以下内容将配合多功能脚本做出说明。。。更新中。。
![24b5c5ed3ccac1bc1a01de1336ffb75](https://user-images.githubusercontent.com/80431714/118347915-2caae680-b579-11eb-97a6-72074b289b73.png)
-------------------------------------------------------------------------------------------------
### 1、开启甲骨文VPS端口（甲骨文专用）：

解决代理协议申请证书发生Nginx等相关报错问题，采用的是简单暴力的删除iptable，完成后将自动断开VPS连接！

--------------------------------------------------------------------------------------------------
### 2、更新甲骨文Ubuntu系统内核（KVM架构VPS通用）：

目前甲骨文Ubuntu20.04系统内核为5.4版本（查看内核版本```uname -r```，已集成于5-10脚本中并自动判断是否大于5.6版本），5.6版本以上内核才集成Wireguard，内核集成方案在理论上网络效率最高！（网络性能：内核集成>内核模块>Wireguard-Go）

----------------------------------------------------------------------------------------------------------------
### 3、开启BBR加速（秋水逸冰版，KVM架构VPS通用）：

按任意键即可安装成功，检测BBR是否生效(显示有BBR，说明成功)：```lsmod | grep bbr```

--------------------------------------------------------------------------------------------------------------------------
### 4、奈非Netflix检测(sjlleo版)：

支持IPV4/IPV6检测，结果非常详细。

---------------------------------------------------------------------------------------------------------------------------
### 5-7、WARP脚本（仅支持IPV4 VPS）：

#### 脚本5(真IPV4+虚IPV6)：IPV6是WARP分配的IP (推荐其他KVM架构IPV4 VPS直接使用，无须输入相关IP)

#### 脚本6(真虚IPV4+虚IPV6)：IPV4与IPV6都是WARP分配的IP（须输入专用IP）

#### 脚本7(真虚IPV4)：       IPV4是WARP分配的IP，无IPV6（须输入专用IP）

---------------------------------------------------------------------------------------------------------------
### 8-10、WARP脚本（仅支持IPV4+IPV6的真双栈VPS，甲骨文支持开启IPV6，直接支持IPV6跳板机，支持IPV4与IPV6双线SSH同时登录！！）：YouTube视频教程下期更新。

#### 脚本8(真IPV4+真虚IPV6)：IPV6是WARP分配的IP (须输入IPV6本地IP)

#### 脚本9(真虚IPV4+真虚IPV6)：IPV4与IPV6都是WARP分配的IP（须输入专用IP与IPV6本地IP）

#### 脚本10(真虚IPV4+真IPV6)：IPV4是WARP分配的IP（须输入专用IP）
------------------------------------------------------------------------------------------------
### 11、永久关闭WARP功能：

停止systemctl stop wg-quick@wgcf

关闭systemctl disable wg-quick@wgcf

作用1：将还原所有VPS本地IP。

作用2：如果当前安装了一种WARP方案，想更新另一种WARP方案，请先关闭WARP功能，再执行安装新的WARP脚本。

---------------------------------------------------------------------------------------------------------------
### 12、启动并开机自启WARP功能：

启动systemctl enable wg-quick@wgcf

开始systemctl start wg-quick@wgcf

---------------------------------------------------------------------------------------------------------
### 13、查看当前VPS的IPV4地址：

```curl -4 ip.p3terx.com```

-----------------------------------------------------------------------------------------------
### 14、查看当前VPS的IPV6地址

```curl -6 ip.p3terx.com```

----------------------------------------------------------------------------------------------------
### 15、mack-a脚本地址：https://github.com/mack-a/v2ray-agent

### 16、phlinhng脚本地址：https://github.com/phlinhng/v2ray-tcp-tls-web

### 注意：域名解析所填写的IP必须是VPS本地IP，与WARP分配的IP没关系！

### （CDN的WS、gRPC协议建议改自选IP地址，如：icook.tw等）

-------------------------------------------------------------------------------------------
### 其他KVM架构VPS查看专用ip方式（待更新）
脚本5不用输入专用IP。其他脚本需要输入专用IP（防止VPS本地IP套WARP后失联），根据不同的VPS，专用IP可能是IP，也可能是IP段。

进入SSH查看专用IP命令：```ip -4 route```或者```ip addr```

结果会显示IP或者IP段，IP段用 /数字 表示！

例：有的VPS公网IP为123.456.2.3，而专用IP段可能就是123.456.0.1/16，此时，要输入的专用IP就是123.456.0.1/16，别忘记输入后面的/16哦！

由于各VPS厂商对专用IP的规定不一，具体大家可以自己尝试，输错了可能导致VPS失联，也就那几个IP或者IP段，。

-------------------------------------------------------------------------------------------------------------

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
