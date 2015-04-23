# AutoDeployVPN 实现的功能
在 CentOS 5/6 上一键自动部署 PPTP 类型 VPN 服务器的 Bash 脚本。



# 安装步骤

####1、下载并执行脚本
在 Linux 终端下，依次输入以下命令：
```shell
wget https://raw.githubusercontent.com/TangBaoping/AutoDeployVPN/master/AutoDeployVPN.sh --no-check-certificate
chmod a+x AutoDeployVPN.sh
bash AutoDeployVPN.sh 
```
（语句说明：第一句为下载脚本，第二句为修改脚本文件的权限，第三句为执行该脚本。)

####2、选择对应系统进行安装
在以下提示中根据你的系统选择对应的选项，如当前系统为 CentOS6 则输入 2 并回车:
```shell
please select your operation system
which do you want to? input the number.
1. my system is centos5 32bit(only support 32bit)
2. my system is centos6 32bit or 64bit(they are support)
3. repaire VPN service
4. add VPN user
```
 命令执行后，将自动下载并安装对应包，成功后返回以下信息：
```shell
  VPN service is installed, your VPN username is vpn,VPN password is ********
```
脚本已经自动创建一个VPN账户，账户名为 VPN ， 后面的*星号为随机字符密码。

####3、如何添加自己的 VPN 帐号
前面安装时脚本自动创建了一个用户名为 VPN 的帐号，如果项添加帐号，可执行以下命令：
```bash
bash AutoDeployVPN.sh 
```
执行后显示以下命令选项，输入 4  敲回车添加 VPN 账户：
```shell
please select your operation system
which do you want to? input the number.
1. my system is centos5 32bit(only support 32bit)
2. my system is centos6 32bit or 64bit(they are support)
3. repaire VPN service
4. add VPN user
```
输入 vpn 账户名，例如要添加账户名为 Tom，密码为 Tom@123：
```bash
input your name:
Tom
input password:
Tom@123
```

####4、如何修改 VPN 帐号密码
如果需要对现有 vpn 帐号进行修改，编辑/etc/ppp/chap-secrets 文件：
```shell
vi /etc/ppp/chap-secrets
```
使用 vi 对该文件内容进行编辑，即可实现 VPN 账户密码的修改：
```shell
# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
Tom				pptpd 	Tom@123 				*
~                                                                                     
~                                                                                     
~                                                                                 
```
（注：client 对应vpn用户名，secret 对应该账户的密码。）
