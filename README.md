### Oracle甲骨文云相关脚本及说明更新中。。。。。

1：
设置Root密码一键脚本
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
2：
3：
…………


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
