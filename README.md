### Oracle甲骨文云相关脚本及说明更新中。。关注Youtube甬哥探世界,,,稍后发布甲骨文最强形态视频教程

#### 一：设置Root密码一键脚本（抛弃秘钥文件，使SSH文件编辑操作、登录方式更加方便）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
#### 二：更新甲骨文Ubuntu系统内核一键脚本
（目前甲骨文Ubuntu20.04系统内核为5.4版本，需更新5.6版本以上自带Wireguard的内核，这是三种WARP安装方式中网络效率最高的）

（以下两个内核升级脚本，选其一即可，都已集成卸载iptables代码，解决甲骨文Ubuntu系统证书申请报错问题）

1、通用内核5.11版本（稳定版）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/generic-kernel.sh)
```
2、第三方xanmod内核（目前5.11.15版本，安装时自动安装最新版本）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/xanmod-kernel.sh)
```

#### 三：开启BBR加速（秋水逸冰大老-稳定版）
```
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
```
##### 检测BBR是否生效：(显示有BBR，说明成功)
```
lsmod | grep bbr
```

三：warp双栈ipv4+ipv6甲骨文最强模式!BBr加速！无视注册区域自动解锁奈飞！！…………更新中…


##### IPV4 VPS专用分流配置文件(以下默认全局IPV4优先)
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
