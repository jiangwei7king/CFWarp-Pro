### Oracle甲骨文云相关脚本及说明更新中。。关注Youtube甬哥探世界,,,稍后发布甲骨文最强形态教程

1：
设置Root密码一键脚本
```
bash <(curl -sSL https://raw.githubusercontent.com/YG-tsj/Oracle-warp/main/root.sh)
```
2：更新内核脚本…稍后……

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
