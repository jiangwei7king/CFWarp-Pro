## 针对KVM架构VPS的WARP一键综合脚本
- [x] 支持 X86与ARM架构
- [x] 支持 纯IPV4  VPS
- [x] 支持 IPV4+IPV6双栈VPS
- [x] 支持 纯IPV6  VPS
-----------------------------------------------------------------------------------------
# 目录

* [相关视频教程](#相关视频教程)

* [root一键脚本](#root一键脚本)

* [vps的ip套上warp功能的优势及不足](#vps的ip套上warp功能的优势及不足)

* [warp多功能一键脚本](#warp多功能一键脚本)

* [warp多功能一键脚本各功能简析](#warp多功能一键脚本各功能简析)

* [自定义ip分流配置模板说明](#自定义ip分流配置模板说明)

* [相关附加说明](#相关附加说明)
-----------------------------------------------------------------------------------------
### 相关视频教程

- [纯IPV4 VPS添加WARP 专用IP是啥？](https://youtu.be/o7e_ikV-m-g)
- [甲骨文添加真IPV6，如何选择WARP脚本看奈非](https://youtu.be/ap_krqWnikE)
- [EUserv 纯ipv6(OpenVZ、LXC架构VPS)WARP项目](https://github.com/YG-tsj/EUserv-warp)
---------------------------------------------------------------------------------------------
### root一键脚本

用户名：root，密码自定义。方便登录与编辑文件！！后续再次执行脚本意味着更改root密码！！

提示：密码不要设置得过于简单，容易被破解。密钥文件要保存好，以防万一！

- **脚本一：适合纯IPV4 VPS与IPV4+IPV6双栈VPS，非ROOT下直接输入以下脚本

```bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)```

- **脚本一：适合纯IPV6  VPS，先执行sudo -i进入root模式后再输入以下脚本

```echo -e nameserver 2a00:1098:2c::1 > /etc/resolv.conf && bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)```

-----------------------------------------------------------------------------------------
### vps的ip套上warp功能的优势及不足

给IPV4/IPV6 only VPS添加WARP的好处：

1：使只有IPV4/IPV6的VPS获取访问IPV6/IPV4的能力，套上WARP的ip，变成双栈VPS！

2：基本能隐藏VPS的真实IP！

3：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

4：加速VPS到CloudFlare CDN节点访问速度！

5：避开原VPS的IP需要谷歌验证码问题！

6：原IPV4下，WARP的IPV6替代HE tunnelbroker IPV6的隧道代理方案，做IPV6 VPS跳板机代理更加稳定！

给IPV4+IPV6双栈VPS添加WARP的好处：
1：基本能隐藏VPS的真实IP！

2：WARP分配的IPV4或者IPV6的IP段，都支持奈非Netflix流媒体，无视VPS原IP限制！

3：加速VPS到CloudFlare CDN节点访问速度！

4：避开原VPS的IP需要谷歌验证码问题！

统一的不足：由于是虚拟的IP，类似宝塔面板等相关工具可能需要另外的设置，这里不作展开。


### warp多功能一键脚本

注意选择适合你VPS的WARP多功能脚本，主要分为以下四类：

脚本一：X86架构~纯IPV4 VPS~IPV4+IPV6双栈VPS

wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/multiX86.sh && chmod +x multiX86.sh && ./multiX86.sh
进入脚本快捷方式 bash ~/multiX86.sh

脚本二：ARM架构~纯IPV4  VPS~IPV4+IPV6双栈VPS

wget -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/multiARM.sh && chmod +x multiARM.sh && ./multiARM.sh
进入脚本快捷方式 bash ~/multiARM.sh

脚本三：X86架构~纯IPV6  VPS

wget -6 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6X86.sh && chmod +x V6X86.sh && ./V6X86.sh
进入脚本快捷方式 bash ~/V6X86.sh

脚本四：ARM架构~纯IPV6  VPS

wget -6 -N --no-check-certificate https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/V6ARM.sh && chmod +x V6ARM.sh && ./V6ARM.sh
进入脚本快捷方式bash ~/V6ARM.sh

### warp多功能一键脚本各功能简析

一、开启甲骨文VPS所有端口（甲骨文专用，务必选择）：
解决代理协议申请证书发生Nginx等相关报错问题，完成后将自动断开VPS连接！

二、更新甲骨文Ubuntu系统内核：
目前甲骨文Ubuntu20.04系统内核为5.4版本，5.6版本以上内核才集成Wireguard，内核集成方案在理论上网络效率最高！（网络性能：内核集成>内核模块>Wireguard-Go）

自动检测内核版本功能已集成于5-10脚本中，5.6以下内核将自动终止脚本运行并提示升级内核！

更新完成后将自动断开VPS连接！

三、开启原生BBR加速（秋水逸冰版）：
按任意键即可安装成功，检测BBR是否生效(显示有BBR，说明成功)：lsmod | grep bbr

四、奈非Netflix检测(sjlleo版)：
支持IPV4/IPV6检测，结果非常详细。


五、安装WARP脚本（仅支持 纯IPV4 VPS）
脚本5、结果表现为2个IP：VPS本地IPV4+WARP虚拟IPV6
脚本6、结果表现为3个IP：VPS本地IPV4+WARP虚拟IPV4+WARP虚拟IPV6
脚本7、结果表现为2个IP：VPS本地IPV4+WARP虚拟IPV4

安装WARP脚本（仅支持IPV4+IPV6双栈VPS）
脚本8、结果表现为3个IP：VPS本地IPV4+VPS本地IPV6+WARP虚拟IPV6
脚本9、结果表现为4个IP：VPS本地IPV4+VPS本地IPV6+WARP虚拟IPV6+WARP虚拟IPV4
脚本10、结果表现为3个IP：VPS本地IPV4+VPS本地IPV6+WARP虚拟IPV4

安装WARP脚本（仅支持 纯IPV6 VPS）
脚本5、结果表现为3个IP：VPS本地IPV6+WARP虚拟IPV6+WARP虚拟IPV4
脚本6、结果表现为2个IP：VPS本地IPV6+WARP虚拟IPV4
目前（VPS本地IPV6+WARP虚拟IPV6）这种形式的应用应该不多吧，日后考虑加上。

六、统一DNS功能：（建议启用）
很多VPS会自动重置DNS并恢复成默认的路由表设置，过程中可能表现为SSH无法下载链接，本功能就是强行设置与warp设定的DNS保持一致，解决偶然情况下SSH无法下载等问题

安装完成后将自动断开VPS连接！

七、永久关闭WARP功能：
作用1：永久关闭WARP分配的虚拟IP，还原当前VPS的本地IP。

作用2：如之前已安装了一种WARP方案，现更换另一种WARP方案，请先关闭WARP功能，再执行安装WARP脚本。

八、启动并开机自启WARP功能：
作用：永久关闭WARP功能后的再次启用。

因WARP脚本默认集成该功能，所以脚本安装成功后不必再执行该项。

九、查看当前VPS的IPV4/IPV6地址：
当前IPV4/IPV6的相关信息：AS号码/ 国家地区/ 所属ISP

十、代理协议脚本选择
支持IPV4/IPV6/X86/ARM的全面脚本 ，推荐！
mack-a脚本地址：https://github.com/mack-a/v2ray-agent

支持IPV4/IPV6/X86的脚本
phlinhng脚本地址：https://github.com/phlinhng/v2ray-tcp-tls-web

注意：域名解析所填写的IP必须是VPS本地IP，与WARP分配的IP没关系！

十一、重启VPS实例（俗话说：重启解决99%的问题）
甲骨文云也可以登录网页，进入实例后台，执行“重新引导”，在后台重启。

### 自定义ip分流配置模板说明

IPV4 VPS WARP专用分流配置文件(以下默认全局IPV4优先，IP、域名自定义教程，参考https://youtu.be/fY9HDLJ7mnM)
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

### 相关附加说明

纯IPV6下登录SSH（确保本地支持IPV6，可参考德鸡EUserv相关教程）

其他KVM架构VPS查看专用ip方式（待更新）
脚本5不用输入专用IP。其他脚本需要输入专用IP（防止VPS本地IP套WARP后失联），根据不同的VPS，专用IP可能是IP，也可能是IP段。

进入SSH查看专用IP命令：ip -4 route或者ip addr

结果会显示IP或者IP段，IP段用 /数字 表示！

例：有的VPS公网IP为123.456.2.3，而专用IP段可能就是123.456.0.1/16，此时，要输入的专用IP就是123.456.0.1/16，别忘记输入后面的/16哦！

由于各VPS厂商对专用IP的规定不一，具体大家可以自己尝试，输错了可能导致VPS失联，也就那几个IP或者IP段，。

提示：配置文件wgcf.conf和注册文件wgcf-account.toml都已备份在/etc/wireguard目录下！

查看WARP当前统计状态：wg


相关WARP进程命令
手动临时关闭WARP网络接口

wg-quick down wgcf
手动开启WARP网络接口

wg-quick up wgcf
启动systemctl enable wg-quick@wgcf

开始systemctl start wg-quick@wgcf

重启systemctl restart wg-quick@wgcf

停止systemctl stop wg-quick@wgcf

关闭systemctl disable wg-quick@wgcf

感谢P3terx大及原创者们，参考来源：

https://p3terx.com/archives/debian-linux-vps-server-wireguard-installation-tutorial.html

https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html

https://luotianyi.vc/5252.html

https://hiram.wang/cloudflare-wrap-vps/
