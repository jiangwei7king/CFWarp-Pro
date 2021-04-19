### Oracle甲骨文云相关脚本及说明更新中。。关注Youtube甬哥探世界,,,稍后发布甲骨文最强形态视频教程

#### 1：设置Root密码一键脚本（使SSH文件编辑操作、登录方式简化）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
#### 2：更新内核脚本
（目前甲骨文Ubuntu20.04系列内核为5.4版本，需更新5.6版本以上自带Wireguard的内核，WARP内核集成方式理论上网络效率最高，以下两个内核升级脚本选其一即可）

通用内核5.11版本（稳定版）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/generic-kernel.sh)
```
第三方xanmod内核（目前5.11.15版本，安装时自动安装最新版本）
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/xanmod-kernel.sh)
```



3：加上ipv6！warp双栈ipv4+ipv6甲骨文最强模式!BBr加速！无视注册区域自动解锁奈飞！！

…………更新中…


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
